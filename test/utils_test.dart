import 'package:cadi_ai/utils/helpers.dart';
import 'package:cadi_ai/utils/config.dart';
import 'package:cadi_ai/entities/history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  List<History>? testHistory = [
    History(
        scanName: "testScan1",
        totalConditionsCount: 6,
        totalAbiotic: 5,
        totalDiseased: 1,
        totalPest: 0),
    History(
        scanName: "testScan2",
        totalConditionsCount: 130,
        totalAbiotic: 13,
        totalDiseased: 87,
        totalPest: 30)
  ];

  group("Test utility and supporting functions in the application", () {
    test("return accurate total crop stress from provided history", () {
      int totalCropStress = getTotalCropStressFromHistory(testHistory);
      expect(totalCropStress, 136);
    });

    test("return accurate gps coordinates of provided image path", () async {
      Map<String, double> imageCoordinates = await getCoordinatesOfImage(
          "${Directory.current.path}/assets/test-image.jpg");

      expect(imageCoordinates["lat"].toString().substring(0, 8), '7.322477');
      expect(imageCoordinates["long"].toString().substring(0, 9), '-2.785858');
    });

    test("return empty object for provided image path with no coordinates",
        () async {
      Map<String, double> imageCoordinates = await getCoordinatesOfImage(
          "${Directory.current.path}/assets/cashew.png");

      expect(imageCoordinates, {});
    });

    testWidgets("return the correct version of the application",
        (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(await AppConfig.getVersion(), "1.0.0");
    });
  });
}
