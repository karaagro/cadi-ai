import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<File> saveImage(Uint8List imageData, String fileName) async {
  Directory tempDir = await getTemporaryDirectory();

  File imageFile = await File('${tempDir.path}/$fileName').create();

  await imageFile.writeAsBytes(imageData);

  return imageFile;
}

Future<Uint8List> downloadImage(String url) async {
  var response = await http.get(Uri.parse(url));
  return Uint8List.fromList(response.bodyBytes);
}

final placeholderImage = File("assets/placeholder.png").readAsBytesSync();
