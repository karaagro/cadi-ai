import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/utils/helpers.dart';
import 'package:cadi_ai/adapters/database_adapter.dart';
import 'package:cadi_ai/entities/image.dart' as isarImage;
import 'package:cadi_ai/services/isar_services.dart';
import 'package:cadi_ai/widgets/HistoryImageLoader.dart';
import 'package:cadi_ai/widgets/ImageDialogTitle.dart';
// ignore: depend_on_referenced_packages
import 'package:latlng/latlng.dart';
import 'package:intl/intl.dart';

class HistoryImageCardsList extends StatefulWidget {
  HistoryImageCardsList({super.key, this.classFilter, this.scale = 0});
  String? classFilter;
  int scale;

  @override
  State<HistoryImageCardsList> createState() => _HistoryImageCardsListState();
}

class _HistoryImageCardsListState extends State<HistoryImageCardsList> {
  final mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    DatabaseAdapter isarService = IsarServices();
    List<isarImage.Image>? scanImageHistory = [];

    Future<List<isarImage.Image>> readScanImagesHistory(int? scanId) {
      return isarService.getImagesForHistory(scanId ?? 0);
    }

    showImageDialog(BuildContext context, int index) {
      Widget closeButton = TextButton(
        child: const Text("Close", style: TextStyle(color: Colors.amber)),
        onPressed: () async {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const ImageDialogTitle(),
        content: SizedBox(
            width: 750,
            height: 500,
            child: Card(
                child: Column(children: [
              Expanded(
                  child: HistoryImageLoader(
                scanImage: scanImageHistory![index].scanImage,
              )),
            ]))),
        actions: [
          closeButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    void onZoomScan(int index) {
      showImageDialog(context, index);
    }

    void setScanImageHistory(List<isarImage.Image>? scanHistory) {
      scanImageHistory = scanHistory;
    }

    int getNumberOfNearCoords(
        double currLat, double currLong, int currCoordsIndex) {
      // ignore: constant_identifier_names
      const NEAR_COORDS_THRESHOLD = 0.0000010;
      int numberOfNearCoords = 0;
      int loopCounter = 0;

      for (LatLng coords in mainController.appState.allScansLatLong) {
        double nearLat = coords.latitude.toPrecision(7);
        double nearLong = coords.longitude.toPrecision(7);

        if ((nearLat - currLat).abs() < NEAR_COORDS_THRESHOLD ||
            (nearLong - currLong).abs() < NEAR_COORDS_THRESHOLD &&
                currCoordsIndex != loopCounter) {
          numberOfNearCoords += 1;
        }
        loopCounter += 1;
      }
      return numberOfNearCoords;
    }

    void calculateAndSetDefaultZoom(currCoordsIndex) {
      double currLat = mainController
          .appState.allScansLatLong[currCoordsIndex].latitude
          .toPrecision(7);
      double currLong = mainController
          .appState.allScansLatLong[currCoordsIndex].longitude
          .toPrecision(7);

      int numberOfNearCoordsToCurrentCoord =
          getNumberOfNearCoords(currLat, currLong, currCoordsIndex);

      if (numberOfNearCoordsToCurrentCoord > 3) {
        mainController.appState.mapController.zoom = 22;
      } else {
        mainController.appState.mapController.zoom = 18;
      }
    }

    void onScanClicked(MainController mainController, int index) {
      calculateAndSetDefaultZoom(index);
      mainController.appState.mapController.center =
          mainController.appState.allScansLatLong[index];
      mainController.appState.selectedScanImageIndex = index.obs;
      mainController.appState.allScansLatLong.refresh();
      mainController.appState.selectedScanImageIndex.refresh();
    }

    void removeAllFromLatLongList() {
      while (mainController.appState.allScansLatLong.isNotEmpty) {
        mainController.appState.allScansLatLong.removeLast();
      }
    }

    LatLng getAverageCenterOfAllCoords(List<LatLng> filteredLatLongs) {
      return filteredLatLongs.reduce((previous, current) {
        return LatLng((previous.latitude + current.latitude) / 2,
            (previous.longitude + current.longitude) / 2);
      });
    }

    void initializeMapCoordsAfterBuild(
        List<isarImage.Image>? filteredScanImages) {
      List<LatLng> filteredLatLongs = filteredScanImages!
          .map((scanImage) =>
              LatLng(scanImage.latCoordinates, scanImage.longCoordinates))
          .toList();

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        removeAllFromLatLongList();
        mainController.appState.mapController.center =
            getAverageCenterOfAllCoords(filteredLatLongs);
        mainController.appState.allScansLatLong.addAll(filteredLatLongs);
        mainController.appState.allScansLatLong.refresh();
        mainController.appState.selectedScanImageIndex = 0.obs;
        mainController.appState.selectedScanImageIndex.refresh();
      });
    }

    List<isarImage.Image>? filterScanImages(
        AsyncSnapshot<List<isarImage.Image>> snapshot) {
      List<isarImage.Image>? filteredScanImages =
          snapshot.data?.where((scanImage) {
        if (widget.classFilter != null) {
          switch (widget.classFilter) {
            case ABIOTIC_FILTER:
              return scanImage.isAbiotic == true;
            case DISEASED_FILTER:
              return scanImage.isDiseased == true;
            case PEST_FILTER:
              return scanImage.isPest == true;
          }
        }
        return true;
      }).toList();

      filteredScanImages
          ?.sort(((a, b) => b.conditionsCount - a.conditionsCount));
      setScanImageHistory(filteredScanImages);

      return filteredScanImages;
    }

    String convertStringToDateTime(String dateTimeString) {
      // Split the date and time components
      List<String> dateTimeComponents = dateTimeString.split(' ');
      String date = dateTimeComponents[0];
      String time = dateTimeComponents[1];

      // Split the year, month, and day components
      List<String> dateComponents = date.split(':');
      int year = int.parse(dateComponents[0]);
      int month = int.parse(dateComponents[1]);
      int day = int.parse(dateComponents[2]);

      // Split the hour, minute, and second components
      List<String> timeComponents = time.split(':');
      int hour = int.parse(timeComponents[0]);
      int minute = int.parse(timeComponents[1]);
      int second = int.parse(timeComponents[2]);

      // Create the DateTime object
      DateTime datetime = DateTime(year, month, day, hour, minute, second);
      String formattedDateTime = DateFormat('MMMM d y').format(datetime);
      return "$formattedDateTime $time";
    }

    return Scaffold(
        body: FutureBuilder<List<isarImage.Image>>(
            future: readScanImagesHistory(
                mainController.appState.selectedHistory.id),
            builder: (context, AsyncSnapshot<List<isarImage.Image>> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.hasData) {
                List<isarImage.Image>? filteredScanImages =
                    filterScanImages(snapshot);
                initializeMapCoordsAfterBuild(filteredScanImages);

                return GetBuilder(
                    builder: (MainController controller) => ListView.builder(
                        itemCount: filteredScanImages?.length,
                        itemBuilder: ((context, index) {
                          return SizedBox(
                            width: 450 + widget.scale.toDouble(),
                            height: 350 + widget.scale.toDouble(),
                            child: Card(
                              child: Column(
                                children: [
                                  Expanded(
                                      child: HistoryImageLoader(
                                    scanImage:
                                        filteredScanImages![index].scanImage,
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, top: 5, bottom: 5, right: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: IconButton(
                                              icon: Image.asset(
                                                'assets/expand.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                              iconSize: 20,
                                              onPressed: () {
                                                onZoomScan(index);
                                              },
                                            )),
                                        SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: TextButton(
                                                onPressed: () => onScanClicked(
                                                    controller, index),
                                                child: const Icon(
                                                  Icons.location_on,
                                                  color: Colors.green,
                                                  size: 20,
                                                ))),
                                        Text(widget.classFilter != null
                                            ? '${widget.classFilter?.replaceAll(RegExp(r'^is'), '')}'
                                            : ''),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${snapshot.data![index].latCoordinates.toString().substring(0, 8)}\n${snapshot.data![index].longCoordinates.toString().substring(0, 8)}",
                                              textScaleFactor: 0.9,
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            DropdownButton<String>(
                                              value: 'Copy',
                                              icon: const Icon(
                                                  Icons.menu_outlined),
                                              elevation: 5,
                                              iconSize: 16,
                                              onChanged:
                                                  (String? action) async {
                                                if (action == 'Copy') {
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                    text:
                                                        "lat: ${snapshot.data![index].latCoordinates.toString()}, long: ${snapshot.data![index].longCoordinates.toString()}",
                                                  ));
                                                }
                                              },
                                              isDense: true,
                                              items: <String>[
                                                'Copy',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 8),
                                    child: Text(
                                      scanImageHistory![index].imageDate != ""
                                          ? convertStringToDateTime(
                                              scanImageHistory![index]
                                                  .imageDate)
                                          : "NA",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })));
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
