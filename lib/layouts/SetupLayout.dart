import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/controllers/SetupController.dart';
import 'package:cadi_ai/pages/Setup/ConfirmSetup.dart';
import 'package:cadi_ai/pages/Setup/Setup.dart';

class SetupLayout extends StatefulWidget {
  const SetupLayout({Key? key}) : super(key: key);

  @override
  State<SetupLayout> createState() => _SetupLayoutState();
}

class _SetupLayoutState extends State<SetupLayout> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SetupController(),
        builder: (SetupController controller) => ConfirmSetup());
  }
}
