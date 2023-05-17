import 'dart:typed_data';
import 'package:isar/isar.dart';
import 'package:cadi_ai/adapters/database_adapter.dart';
import 'package:cadi_ai/entities/appstate.dart';
import 'package:cadi_ai/entities/history.dart';
import 'package:cadi_ai/entities/image.dart';
import 'dart:io';
import 'package:cadi_ai/entities/settings.dart';
import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class IsarServices extends DatabaseAdapter {
  late Future<Isar> db;

  IsarServices() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
          schemas: [HistorySchema, ImageSchema, SettingsSchema],
          inspector: true,
          directory: appDocPath);
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<History> saveScan(History scanHistory) async {
    Isar dbConnected = await db;

    return dbConnected.writeTxn((isarLocal) async =>
        scanHistory..id = await isarLocal.historys.put(scanHistory));
  }

  Future<void> deleteScan() async {
    final isar = await db;
    await isar
        .writeTxn((isar) async => await isar.historys.where().deleteAll());
  }

  @override
  Future<void> saveScanImages(ScanImageItem scanImageItem) async {
    Isar dbConnected = await db;
    final image = Image(
        historyId: scanImageItem.historyId,
        scanImage: scanImageItem.imageBytes,
        latCoordinates: scanImageItem.latCoordinates,
        longCoordinates: scanImageItem.longCoordinates,
        conditionsCount: scanImageItem.conditionsCount,
        isAbiotic: scanImageItem.isAbiotic,
        isDiseased: scanImageItem.isDiseased,
        isPest: scanImageItem.isPest,
        imageDate: scanImageItem.imageDate);
    dbConnected
        .writeTxn((isar) async => image..id = await isar.images.put(image));
  }

  Future<void> deleteImages() async {
    final isar = await db;
    await isar.writeTxn((isar) async => await isar.images.where().deleteAll());
  }

  @override
  Future<List<History>> getAllHistory() async {
    Isar dbConnected = await db;
    final histories = await dbConnected.historys.where().findAll();
    return histories.map((history) => history).toList();
  }

  Future<void> updateHistory(History history) async {
    await updateHistorySynced(history, false);
  }

  Future<void> updateHistorySynced(History history, bool isSynced) async {
    history.isSynced = isSynced;
    Isar dbConnected = await db;
    await dbConnected
        .writeTxn((isar) async => await isar.historys.put(history));
  }

  @override
  Future<List<Image>> getImagesForHistory(int id) async {
    Isar dbConnected = await db;
    final images = await dbConnected.images
        .where()
        .filter()
        .historyIdEqualTo(id)
        .findAll();
    return images.map((image) => image).toList();
  }

  Future<void> deleteImagesForHistory(int id) async {
    final isar = await db;
    await isar.writeTxn((isar) async =>
        await isar.images.where().filter().historyIdEqualTo(id).deleteAll());
  }

  Future<void> addSetting(Settings newSetting) async {
    final isar = await db;
    isar.writeTxnSync((isar) => isar.settingss.putSync(newSetting));
  }

  Future getSettingByKey(String key) async {
    final isar = await db;
    final setting = await isar.settingss.filter().keyEqualTo(key).findFirst();
    return setting;
  }

  Future updateSetting(String key) async {
    final isar = await db;
    final setting = await isar.settingss.filter().keyEqualTo(key).findFirst();
    setting?.value = 'true';
    await isar.writeTxn((isar) async => isar.settingss.put(setting!));
  }

  Future<void> deleteSettings() async {
    final isar = await db;
    await isar
        .writeTxn((isar) async => await isar.settingss.where().deleteAll());
  }
}
