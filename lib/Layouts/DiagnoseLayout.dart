import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/Pages/DiagnosisForm.dart';

class DiagnoseLayout extends StatelessWidget {
  const DiagnoseLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        builder: (MainController controller) => Scaffold(
                body: IndexedStack(
              children: const [
                NewDiagnoseForm(),
                SizedBox(
                  height: 300,
                  child: Text('Result'),
                ),
              ],
            )));
  }
}
