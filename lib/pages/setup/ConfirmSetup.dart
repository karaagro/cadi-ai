import 'dart:io';
import 'package:cadi_ai/layouts/HomeLayout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/controllers/SetupController.dart';
import 'package:cadi_ai/pages/setup/Setup.dart';
import 'package:cadi_ai/Utils/PageRoutes.dart';

class ConfirmSetup extends StatelessWidget {
  const ConfirmSetup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SetupController(),
        builder: (SetupController controller) => Scaffold(
              body: Center(
                child: Container(
                  width: 650,
                  height: 300,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(136, 32, 32, 32),
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Welcome to CADI AI",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            "Certain packages need to be installed in order to use the application. A stable internet connection and 100MB of disk space is required to complete this step. Data charges may apply.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          SizedBox(
                            width: 500,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // exit(0);
                                      Get.offAndToNamed(
                                          PageRoutes.HOME_PAGE.name);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.amber),
                                      foregroundColor: Colors.amber,
                                    ),
                                    child: const Text('Later'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Setup(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.black,
                                    ),
                                    child: const Text('Continue'),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ));
  }
}
