import 'dart:io';

import 'package:flutter/foundation.dart';

const String database = 'db';
const String positiveStoreImages = 'positive_store_images';

Future createDefaultDirs() async {
  for (var folder in [database, positiveStoreImages]) {
    final path = Directory(folder);
    if (path.existsSync()) {
      if (kDebugMode) {
        print("exist: ${path.absolute}");
      }
    } else {
      if (kDebugMode) {
        print("not exist");
      }
      path.create();
    }
  }
}
