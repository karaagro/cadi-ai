// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cadi_ai/utils/strings.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/utils/helpers.dart';
import 'package:cadi_ai/adapters/database_adapter.dart';
import 'package:cadi_ai/entities/appstate.dart';
import 'package:cadi_ai/entities/history.dart';
import 'package:cadi_ai/services/ai_services.dart';
import 'package:cadi_ai/services/isar_services.dart';
import 'package:cadi_ai/widgets/ScanProgress.dart';
import 'package:cadi_ai/widgets/snackbars.dart';
import 'package:cadi_ai/widgets/testAnimation.dart';

class NewDiagnoseForm extends StatefulWidget {
  const NewDiagnoseForm({
    Key? key,
  }) : super(key: key);

  @override
  State<NewDiagnoseForm> createState() => _NewDiagnoseFormState();
}

class _NewDiagnoseFormState extends State<NewDiagnoseForm> {
  DatabaseAdapter isarService = IsarServices();
  TextEditingController textAreaController = TextEditingController();
  int totalFailedImageScans = 0;
  int totalCleanImageScans = 0;
  int totalImagesToScan = 0;
  bool diagnosing = false;

  double calculateProgress(int total, int remaining) {
    double percentage = (total - remaining) / total * 100.0;
    return percentage;
  }

  void checkReadyAndDoScan(MainController controller) async {
    if (controller.appState.scanName.isNotEmpty) {
      doScan(controller);
    } else {
      showSimpleSnackBar(
          context: context,
          message: "Scan name and/or image(s) cannot be empty",
          bgColor: Colors.blue);
    }
  }

  void doScan(MainController controller) async {
    List<File> scanFiles = controller.filesDropped.toList();
    List<String> resultPaths = [];
    List<Map<String, int>> conditionCounters = [];
    List<Map<String, double>> scanCoordinates = [];
    String scanImageDate = "NA";

    setTotalImagesToScan(scanFiles.length);
    setDiagnosingTrue();
    showDialog(
        barrierDismissible: false,
        barrierColor: const Color(0x01000000),
        context: context,
        builder: (context) {
          return const Center();
        });

    try {
      for (var scanItem in scanFiles) {
        var data = await postData(Uri.parse('http://127.0.0.1:5000/'),
            json.encode({'imagePath': scanItem.path}));
        List<dynamic> decodedConditions =
            jsonDecode(jsonDecode(data)['conditions']);
        String imagePath = jsonDecode(data)['imagePath'];
        Map<String, double> scanCoordinate =
            await getCoordinatesOfImage(scanItem.path);
        Map<String, String> scanImageDateMap =
            await getDateOfImage(scanItem.path);
        scanImageDate = scanImageDateMap['date'] ?? "NA";

        if (scanCoordinate.isEmpty) {
          handleScanImageWithNoCoordinates(imagePath);
        } else if (decodedConditions.isEmpty) {
          handleScanImageWithNoDetectedConditions(imagePath);
        } else {
          scanCoordinates.add(scanCoordinate);
          conditionCounters.add(getConditionCounts(decodedConditions));
          resultPaths.add(imagePath);
          reduceTotalImagesToScan();
        }
      }
      await saveScanBoundingBoxImagesInDb(controller, scanCoordinates,
          resultPaths, conditionCounters, scanImageDate);
      setDiagnosingFalse();
      Navigator.pop(context);
      checkAndShowTotalFailedScansSnackbar(context);
      cleanupAndRouteToHistory(controller);
    } catch (error) {
      setDiagnosingFalse();
      Navigator.pop(context);
      showSimpleSnackBar(
          context: context,
          message:
              "Scan failed due to inability to reach AI service. Restart the application and try again",
          bgColor: Colors.red);
    }
  }

  void handleScanImageWithNoCoordinates(String scanImagePath) {
    addToTotalFailedImageScans();
    reduceTotalImagesToScan();
    deleteScanImageAt(File(getDeviceSpecificPath(scanImagePath)).parent);
  }

  void handleScanImageWithNoDetectedConditions(String scanImagePath) {
    addToTotalCleanImageScans();
    reduceTotalImagesToScan();
    deleteScanImageAt(File(getDeviceSpecificPath(scanImagePath)).parent);
  }

  Future saveScanBoundingBoxImagesInDb(
      MainController controller,
      List<Map<String, double>> scanCoordinates,
      List<String> imagePaths,
      List<Map<String, int>> conditionCounters,
      String scanImageDate) async {
    Map<String, int> totalConditionCounts =
        getTotalConditionCounts(conditionCounters);

    History history = History(
        scanName: controller.appState.scanName,
        totalConditionsCount: totalConditionCounts[conditionsCountKey]!,
        totalAbiotic: totalConditionCounts[abioticCountKey]!,
        totalDiseased: totalConditionCounts[diseasedCountKey]!,
        totalPest: totalConditionCounts[pestCountKey]!);

    int index = 0;
    for (var filePath in imagePaths) {
      File file = File(getDeviceSpecificPath(filePath));
      Uint8List imageBytes = await file.readAsBytes();
      History savedHistory = await isarService.saveScan(history);
      await isarService.saveScanImages(ScanImageItem(
          historyId: savedHistory.id!,
          imageBytes: imageBytes,
          latCoordinates: scanCoordinates[index]['lat']!,
          longCoordinates: scanCoordinates[index]['long']!,
          conditionsCount: conditionCounters[index][conditionsCountKey]!,
          isAbiotic:
              conditionCounters[index][abioticCountKey]! > 0 ? true : false,
          isDiseased:
              conditionCounters[index][diseasedCountKey]! > 0 ? true : false,
          isPest: conditionCounters[index][pestCountKey]! > 0 ? true : false,
          imageDate: scanImageDate));
      index++;
      deleteScanImageAt(file.parent);
    }
  }

  void checkAndShowTotalFailedScansSnackbar(BuildContext context) {
    if (totalFailedImageScans > 0) {
      showSimpleSnackBar(
          context: context,
          message:
              "$totalFailedImageScans Not Scanned, $totalCleanImageScans Scanned With No Conditions",
          bgColor: Colors.blue);
    }
  }

  String getDeviceSpecificPath(String filePath) {
    if (Platform.isMacOS) {
      return getAIGeneratedImageUsablePath(filePath);
    }
    // return default device: Windows
    return filePath;
  }

  String getAIGeneratedImageUsablePath(String filePath) {
    return filePath.replaceAll(RegExp(r'^\/'), '');
  }

  void setDiagnosingTrue() {
    setState(() {
      diagnosing = true;
    });
  }

  void setDiagnosingFalse() {
    setState(() {
      diagnosing = false;
    });
  }

  void addToTotalCleanImageScans() {
    setState(() {
      totalCleanImageScans++;
    });
  }

  void addToTotalFailedImageScans() {
    setState(() {
      totalFailedImageScans++;
    });
  }

  void reduceTotalImagesToScan() {
    setState(() {
      totalImagesToScan--;
    });
  }

  void setTotalImagesToScan(totalScanImages) {
    setState(() {
      totalImagesToScan = totalScanImages;
    });
  }

  void cleanupAndRouteToHistory(MainController controller) {
    controller.appState.totalCleanImageScans = totalCleanImageScans;
    controller.appState.totalFailedImageScans = totalFailedImageScans;

    totalFailedImageScans = 0;
    totalCleanImageScans = 0;
    textAreaController.clear();

    controller.appState.scanName = "";
    controller.updateApplicationState();
    controller.updateSelectedFilesList([]);

    controller.updateSideMenuStackIndex(1);
  }

  void deleteScanImageAt(Directory directoryToDelete) {
    directoryToDelete.delete(recursive: true);
  }

  bool isAllReadyForScan(MainController controller) {
    return controller.appState.isServerOnline &&
        controller.appState.scanName.isNotEmpty &&
        controller.filesDropped.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (MainController controller) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SizedBox(
            height: 650,
            width: 600,
            child: Card(
              shadowColor: Colors.black54,
              elevation: 40,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Divider(
                  height: 80,
                  color: Colors.transparent,
                ),
                SizedBox(
                  height: 70,
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Title'),
                      const Spacer(),
                      TextFormField(
                        controller: textAreaController,
                        onChanged: (value) {
                          controller.appState.scanName = value;
                          controller.updateApplicationState();
                        },
                        cursorColor: Colors.amber,
                        decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            hintText: 'Enter title of this scan',
                            border: OutlineInputBorder(
                                gapPadding: 0,
                                borderSide: BorderSide(
                                    style: BorderStyle.none, width: 0))),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 40,
                  color: Colors.transparent,
                ),
                diagnosing
                    ? ScanProgress(
                        percentage: calculateProgress(
                            controller.filesDropped.length, totalImagesToScan))
                    : const filePicker(),
                const Divider(
                  height: 40,
                  color: Colors.transparent,
                ),
                Text(
                  '${controller.filesDropped.length} images uploaded',
                  style: const TextStyle(fontSize: 20),
                ),
                const Divider(
                  height: 40,
                  color: Colors.transparent,
                ),
                SizedBox(
                  width: 300,
                  child: MouseRegion(
                      cursor: controller.appState.isServerOnline
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.basic,
                      onHover: controller.appState.isServerOnline
                          ? (event) {}
                          : null,
                      child: ElevatedButton(
                          onPressed: isAllReadyForScan(controller)
                              ? () => checkReadyAndDoScan(controller)
                              : null,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                isAllReadyForScan(controller)
                                    ? Colors.amber
                                    : Colors.grey),
                          ),
                          child: const Text('Scan'))),
                ),
                const SizedBox(
                  height: 24,
                ),
                controller.appState.isServerOnline
                    ? const Text(
                        "Service is online",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      )
                    : (controller.appState.isServerStartFailed
                        ? const Text(
                            "Service start failed",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          )
                        : textAnimation(
                            text: "Initializing AI service...",
                            controller: controller
                                .appState.aiServiceAnimationController,
                            font_size: 14,
                          )),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 60),
                  child: SizedBox(
                    height: 80,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        SCANNING_REQUIREMENTS,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class filePicker extends StatelessWidget {
  const filePicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        builder: (MainController controller) => InkWell(
              onTap: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                if (result != null) {
                  // GET imgaes from tmp
                  List<File> files =
                      result.paths.map((path) => File(path!)).toList();
                  controller.updateSelectedFilesList(files);
                } else {
                  // User canceled the picker
                }
              },
              child: DropTarget(
                enable: true,
                onDragDone: (detail) {
                  if (detail.files.last.path.contains('.')) {
                    final fileCopy = <File>[];
                    for (var element in detail.files) {
                      if (element.path.isImageFileName) {
                        fileCopy.add(File(element.path));
                      }
                    }
                    controller.updateSelectedFilesList(fileCopy);
                  }
                  if (!detail.files.last.path.contains('.')) {
                    final dir = Directory(detail.files.last.path);
                    final list = dir.listSync();
                    final fileCopy = <File>[];
                    for (var element in list) {
                      if (element.path.isImageFileName) {
                        fileCopy.add(File(element.path));
                      }
                    }
                    controller.updateSelectedFilesList(fileCopy);
                    fileCopy.clear();
                  }
                  controller.updateFileDropped(isDropped: true);
                },
                child: DottedBorder(
                  color: Colors.amber.shade700,
                  borderType: BorderType.RRect,
                  dashPattern: const [12, 10, 12, 10],
                  radius: const Radius.circular(6),
                  padding: const EdgeInsets.all(0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: controller.isFileDropped
                              ? Colors.grey.withOpacity(0.4)
                              : Colors.black26,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      alignment: Alignment.center,
                      height: 100,
                      width: 400,
                      child: controller.filesDropped.isEmpty
                          ? const Center(
                              child: Text(
                              "Drag and drop / select images from your computer",
                              style: TextStyle(color: Colors.white60),
                            ))
                          : Text(
                              '${controller.filesDropped.length} images selected',
                              style: const TextStyle(color: Colors.white60),
                            )),
                ),
              ),
            ));
  }
}
