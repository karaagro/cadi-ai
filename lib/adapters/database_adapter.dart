import 'dart:typed_data';

import 'package:cadi_ai/entities/appstate.dart';
import 'package:cadi_ai/entities/history.dart';
import 'package:cadi_ai/entities/image.dart';

abstract class DatabaseAdapter {
  Future<History> saveScan(History scanHistory);
  Future<void> saveScanImages(ScanImageItem scanImageItem);
  Future<List<History>> getAllHistory();
  Future<List<Image>> getImagesForHistory(int id);
}
