import 'dart:typed_data';
import 'package:isar/isar.dart';
import 'package:cadi_ai/utils/images.dart';

part 'image.g.dart';

@Collection()
class Image {
  Image(
      {required this.historyId,
      required this.scanImage,
      required this.latCoordinates,
      required this.longCoordinates,
      required this.conditionsCount,
      required this.isAbiotic,
      required this.isDiseased,
      required this.isPest,
      required this.imageDate});

  @Id()
  int? id;
  int historyId;
  Uint8List scanImage;
  double latCoordinates;
  double longCoordinates;
  DateTime timestamp = DateTime.now();
  String imageDate;
  int conditionsCount;
  bool isAbiotic;
  bool isDiseased;
  bool isPest;

  static Future<Image> fromJson(Map<String, dynamic> json) async {
    Uint8List? imageBytes;
    try {
      imageBytes = await downloadImage(json['url']);
    } catch (err) {
      imageBytes = placeholderImage;
    }

    var image = Image(
        historyId: json['historyId'],
        scanImage: imageBytes,
        latCoordinates: json['latCoordinates'] ?? 0,
        longCoordinates: json['longCoordinates'] ?? 0,
        conditionsCount: json['conditionsCount'] ?? 0,
        isAbiotic: json['isAbiotic'] ?? false,
        isDiseased: json['isDiseased'] ?? false,
        isPest: json['isPest'] ?? false,
        imageDate: json['imageDate'] ?? "NA");

    image.id = json['id'];
    image.timestamp = DateTime.parse(json['timestamp']);

    return image;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'historyId': historyId,
      'latCoordinates': latCoordinates,
      'longCoordinates': longCoordinates,
      'timestamp': timestamp.toIso8601String(),
      'conditionsCount': conditionsCount,
      'isAbiotic': isAbiotic,
      'isDiseased': isDiseased,
      'isPest': isPest,
    };
  }
}
