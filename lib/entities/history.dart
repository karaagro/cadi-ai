import 'package:isar/isar.dart';

part 'history.g.dart';

@Collection()
class History {
  History(
      {required this.scanName,
      required this.totalConditionsCount,
      required this.totalAbiotic,
      required this.totalDiseased,
      required this.totalPest});

  @Id()
  int? id;
  String scanName;
  DateTime timestamp = DateTime.now();
  bool isSynced = false;
  int totalConditionsCount = 0;
  int totalAbiotic = 0;
  int totalDiseased = 0;
  int totalPest = 0;

  factory History.fromJson(Map<String, dynamic> json) {
    var history = History(
        scanName: json['scanName'],
        totalConditionsCount: json['totalConditions'] ?? 0,
        totalAbiotic: json['totalAbiotic'] ?? 0,
        totalDiseased: json['totalDiseased'] ?? 0,
        totalPest: json['totalPest'] ?? 0);

    history.id = json['id'];
    history.timestamp = DateTime.parse(json['timestamp']);
    history.isSynced = true;

    return history;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scanName': scanName,
      'timestamp': timestamp.toIso8601String(),
      'totalConditions': totalConditionsCount,
      'totalAbiotic': totalAbiotic,
      'totalDiseased': totalDiseased,
      'totalPest': totalPest
    };
  }
}
