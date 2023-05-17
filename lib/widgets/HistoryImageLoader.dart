import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HistoryImageLoader extends StatelessWidget {
  HistoryImageLoader({super.key, required this.scanImage});

  Uint8List scanImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Image.memory(scanImage),
    );
  }
}
