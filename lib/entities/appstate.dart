import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:cadi_ai/entities/history.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class AppState {
  late AnimationController aiServiceAnimationController;
  final MapController mapController = MapController(
    location: LatLng(5.6557387, -0.1582376),
  );
  Function updateMapState = () {};

  History selectedHistory = History(
      scanName: "default",
      totalConditionsCount: 0,
      totalAbiotic: 0,
      totalDiseased: 0,
      totalPest: 0);

  RxList<LatLng> allScansLatLong = <LatLng>[].obs;
  RxInt selectedScanImageIndex = 0.obs;

  bool isServerOnline = false;
  bool isServerStartFailed = false;
  bool isStateValuesInitialized = false;

  int totalFailedImageScans = 0;
  int totalCleanImageScans = 0;
  int selectedHistoryStackIndex = 0;
  int selectedSideMenuStackIndex = 0;

  int? totalCropStress = 0;
  int? totalDiagnoses = 0;

  String scanName = "";
}

class ScanImageItem {
  ScanImageItem(
      {required this.historyId,
      required this.imageBytes,
      required this.longCoordinates,
      required this.latCoordinates,
      required this.conditionsCount,
      required this.isAbiotic,
      required this.isDiseased,
      required this.isPest,
      required this.imageDate});
  late int historyId;
  late Uint8List imageBytes;
  late double longCoordinates;
  late double latCoordinates;
  late int conditionsCount;
  late bool isAbiotic;
  late bool isDiseased;
  late bool isPest;
  late String imageDate;
}
