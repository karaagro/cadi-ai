import 'package:get/get.dart';
import 'package:cadi_ai/layouts/HomeLayout.dart';
import 'package:cadi_ai/layouts/SetupLayout.dart';
import 'package:cadi_ai/Utils/PageRoutes.dart';

class Pages {
  static final pageList = [
    GetPage(
        name: '/${PageRoutes.HOME_PAGE.name}', page: () => const HomeLayout()),
    GetPage(
        name: '/${PageRoutes.SETUP_LAYOUT.name}',
        page: () => const SetupLayout()),
  ];
}
