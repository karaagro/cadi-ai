import 'package:isar/isar.dart';
import 'package:cadi_ai/entities/history.dart';
import 'package:cadi_ai/entities/image.dart';

@Collection()
class LocalTestHistory {
  LocalTestHistory({required this.history, required this.images});

  History history;
  List<Image> images;
}
