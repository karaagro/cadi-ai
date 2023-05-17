import 'dart:io';

import 'package:get/get.dart';
import 'package:cadi_ai/Utils/helpers.dart';
import 'package:cadi_ai/entities/LocalTestHistory.dart';
import 'package:cadi_ai/entities/appstate.dart';
import 'package:cadi_ai/entities/history.dart';
import 'package:latlng/latlng.dart';

class MainController extends GetxController {
  bool isFileDropped = false;
  List<File> filesDropped = [];
  late LocalTestHistory localTestHistory;
  bool isFirestoreAuthenticated = false;
  AppState appState = AppState();

  void updateApplicationState() {
    update();
  }

  void updateHistoryStackIndex(int newHistoryIndex) {
    appState.selectedHistoryStackIndex = newHistoryIndex;
    updateApplicationState();
  }

  void updateSideMenuStackIndex(int newSideMenuIndex) {
    appState.selectedSideMenuStackIndex = newSideMenuIndex;
    updateApplicationState();
  }

  updateTotalCropStress(List<History>? allHistory) async {
    int totalCropStressFoundInHistory =
        getTotalCropStressFromHistory(allHistory);
    if (totalCropStressFoundInHistory != appState.totalCropStress) {
      appState.totalCropStress = totalCropStressFoundInHistory;
      updateApplicationState();
    }
  }

  updateTotalDiagnosis(List<History>? allHistory) async {
    if (allHistory?.length != appState.totalDiagnoses) {
      appState.totalDiagnoses = allHistory?.length;
      updateApplicationState();
    }
  }

  setDefaultHome(history) {
    if (!appState.isStateValuesInitialized) {
      appState.isStateValuesInitialized = true;
      updateSideMenuStackIndex(history!.isNotEmpty ? 1 : 0);
      updateApplicationState();
    }
  }

  void updateSelectedHistory(History history) {
    appState.selectedHistory = history;
    updateApplicationState();
  }

  void updateSelectedLocalHistory(LocalTestHistory history) {
    localTestHistory = history;
    updateApplicationState();
  }

  void updateFileDropped({required bool isDropped}) {
    isFileDropped = isDropped;
    updateApplicationState();
  }

  void updateSelectedFilesList(List<File> files) {
    filesDropped.clear();
    filesDropped = files;
    updateApplicationState();
  }

  void updateFirestoreAuthentication(bool isAuthenticated) {
    isFirestoreAuthenticated = isAuthenticated;
    updateApplicationState();
  }
}
