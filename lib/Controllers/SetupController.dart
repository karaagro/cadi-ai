import 'package:get/get.dart';

///This file contains all the authentication logics from signup to login
class SetupController extends GetxController {
  int pageIndex = 0;

  ///set the current app page index
  void updatePageIndex(int index) {
    pageIndex = index;
    update();
  }
}
