import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/pages/MapDisplay.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/instance_manager.dart';

void main() {
  group("Test MapDisplay features", () {
    testWidgets("should not zoom pass 22 levels", (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 30));
      Get.lazyPut(() => MainController());
      MapDisplayState map = MapDisplayState();
      for (var i = 1; i <= 100; i++) {
        map.onZoomIn();
      }
      expect(map.mainController.appState.mapController.zoom, 22);
    });
  });
}
