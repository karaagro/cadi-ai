import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/themes/app_theme.dart';
import 'package:cadi_ai/Utils/PageInits.dart';
import 'package:cadi_ai/Utils/PageRoutes.dart';
import 'utils/controller_bindings.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // locale: Get.deviceLocale,
      defaultTransition: Transition.fadeIn,
      initialBinding: ControllerBindings(),
      // unknownRoute: GetPage(name: '/', page: () => const BusinessListView()),
      initialRoute: PageRoutes.HOME_PAGE.name,
      getPages: Pages.pageList,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, //ThemeMode.system,
      localizationsDelegates: const [
        // FormBuilderLocalizations.delegate,
      ],
    );
  }
}
