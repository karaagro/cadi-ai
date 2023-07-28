import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image, MenuItem;
import 'package:get/get.dart';
import 'package:cadi_ai/layouts/AboutLayout.dart';
import 'package:cadi_ai/layouts/HomeLayout.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/layouts/DiagnoseLayout.dart';
import 'package:cadi_ai/layouts/HistoryLayout.dart';
import 'package:cadi_ai/utils/internet_connectivity_checker.dart';
import 'package:cadi_ai/entities/history.dart';
import 'package:cadi_ai/entities/image.dart';
import 'package:cadi_ai/services/ai_services.dart';
import 'package:cadi_ai/services/isar_services.dart';
import 'package:cadi_ai/widgets/MenuItem.dart';
import 'package:cadi_ai/widgets/snackbars.dart';
import 'package:cadi_ai/utils/PageRoutes.dart';
import 'package:cadi_ai/entities/settings.dart';

class HomeLayoutState extends State<HomeLayout>
    with SingleTickerProviderStateMixin {
  IsarServices isarService = IsarServices();
  final mainController = Get.find<MainController>();
  late List<Widget> menuPages;
  late Timer _timer;
  int? processId;

  void navigateSidemenu(int index) {
    mainController.updateSideMenuStackIndex(index);
  }

  @override
  void initState() {
    super.initState();
    setMenuPages();
    startAIService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await startSetupProcess();
      startPollingAIService();
    });
  }

  void startPollingAIService() {
    mainController.appState.aiServiceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    mainController.updateApplicationState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      checkServerStatus();
    });
  }

  Future<void> checkServerStatus() async {
    var data = await getData(Uri.parse('http://127.0.0.1:5000/'));
    var res = jsonDecode(data);
    if (res['status'] == "OK") {
      _timer.cancel();
      mainController.appState.isServerOnline = true;
      mainController.updateApplicationState();
    }
  }

  void setMenuPages() {
    menuPages = [
      const DiagnoseLayout(),
      const HistoryLayout(),
      const AboutLayout()
    ];
  }

  Future<void> startSetupProcess() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const CircularProgressIndicator(),
            ),
          ),
        );
      },
    );

    final setting = await isarService.getSettingByKey('setUpComplete');
    if (setting == null) {
      await isarService.addSetting(Settings()
        ..key = 'setUpComplete'
        ..value = 'false');
      Get.offAndToNamed(PageRoutes.SETUP_LAYOUT.name);
    } else if (setting.value == 'false') {
      Get.offAndToNamed(PageRoutes.SETUP_LAYOUT.name);
    } else {
      Navigator.pop(context);
    }
  }

  void startAIService() async {
    final process =
        await Process.start(getDeviceSpecificPython(), ['-m', 'flask', 'run']);
    process.stdout.transform(utf8.decoder).listen((data) {
      if (kDebugMode) {
        print('stdout: $data');
      }
    });
    process.stderr.transform(utf8.decoder).listen((data) {
      if (kDebugMode) {
        print('stderr: $data');
      }
      if (data.contains("timeout")) {
        mainController.appState.isServerStartFailed = true;
        mainController.updateApplicationState();
        showSimpleSnackBar(
            context: context,
            message:
                "Failed to start AI Service. Connect to the internet and try again",
            bgColor: Colors.red);
      }
    });
    process.exitCode.then((exitCode) {
      if (exitCode == 0) {
        processId = process.pid;
        if (kDebugMode) {
          print(process.pid);
          print('Flask server started.');
        }
      } else {
        if (kDebugMode) {
          print('Failed to start Flask server.');
          print(exitCode);
        }
      }
    }).catchError((error) {
      showSimpleSnackBar(
          context: context, message: "Failed to start AI service");
    });
  }

  String getDeviceSpecificPython() {
    if (Platform.isMacOS) {
      return "python3";
    }
    // return default device: Windows
    return "python";
  }

  Future<List<History>> readScanHistory() async {
    return await isarService.getAllHistory();
  }

  Future<List<Image>> readScanImagesHistory(int? scanId) {
    return isarService.getImagesForHistory(scanId ?? 0);
  }

  void initializeStateValues(List<History>? history) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainController.updateTotalCropStress(history);
      mainController.updateTotalDiagnosis(history);
      mainController.setDefaultHome(history);
    });
  }

  void resetHistoryStackOrder(MainController controller) {
    controller.updateHistoryStackIndex(0);
  }

  void cleanUpAIServicePolling() {
    _timer.cancel();
    mainController.appState.aiServiceAnimationController.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    stopListeningToConnectivityChanges();
    cleanUpAIServicePolling();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<History>>(
        future: readScanHistory(),
        builder: (context, AsyncSnapshot<List<History>> snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              print("error: ${snapshot.error} ${snapshot.stackTrace}");
            }
            return const Center(
              child: Text("Something went wrong. Please restart application"),
            );
          }
          if (snapshot.hasData) {
            initializeStateValues(snapshot.data);

            return GetBuilder(
              builder: (MainController controller) => Scaffold(
                appBar: AppBar(
                  backgroundColor:
                      Get.isDarkMode ? Colors.black87 : Colors.grey,
                  centerTitle: false,
                  title: const Text('CADI AI'),
                  elevation: 0,
                  actions: const [],
                ),
                body: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: double.infinity,
                        width: 300,
                        color: Colors.black,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 60),
                              height: 140,
                              child: Wrap(
                                alignment: WrapAlignment.spaceAround,
                                spacing: 50,
                                runSpacing: 12,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${controller.appState.totalDiagnoses}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18),
                                      ),
                                      const Text('Diagnosis')
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${controller.appState.totalCropStress}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const Text('Crop Stress')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            MenuItem(
                                "Diagnose",
                                (controller
                                        .appState.selectedSideMenuStackIndex ==
                                    0), () {
                              resetHistoryStackOrder(controller);
                              controller.updateSideMenuStackIndex(0);
                            }),
                            MenuItem(
                                "History",
                                (controller
                                        .appState.selectedSideMenuStackIndex ==
                                    1), () {
                              resetHistoryStackOrder(controller);
                              controller.updateSideMenuStackIndex(1);
                            }),
                            MenuItem(
                                "About",
                                (controller
                                        .appState.selectedSideMenuStackIndex ==
                                    2), () {
                              resetHistoryStackOrder(controller);
                              controller.updateSideMenuStackIndex(2);
                            }),
                          ],
                        ),
                      ),
                      Expanded(
                          child: menuPages[
                              controller.appState.selectedSideMenuStackIndex])
                    ]),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
