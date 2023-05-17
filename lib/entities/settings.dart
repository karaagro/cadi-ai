import 'package:isar/isar.dart';

part 'settings.g.dart';

@Collection()
class Settings {
  int id = isarAutoIncrementId;
  late String key;
  late String value;
}
