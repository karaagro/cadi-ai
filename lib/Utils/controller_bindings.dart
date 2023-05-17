import 'package:get/get.dart';
import 'package:cadi_ai/controllers/MainController.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
}
