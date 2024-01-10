import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/Utils/PageRoutes.dart';
import 'package:cadi_ai/services/isar_services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:io';
import 'dart:convert';
import 'package:cadi_ai/controllers/SetupController.dart';
import 'package:cadi_ai/entities/settings.dart';
import 'package:path_provider/path_provider.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  SetupController controller = SetupController();
  IsarServices isarServices = IsarServices();
  int progress = 0;
  String step = '';

  void completeSetup() async {
    await isarServices.updateSetting('setUpComplete');
    Get.offAndToNamed(PageRoutes.HOME_PAGE.name);
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK", style: TextStyle(color: Colors.amber)),
      onPressed: () {
        exit(0);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Application Setup"),
      content:
          const Text("Restart the application to complete the setup process"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool validatePythonVersion(String versionOutput) {
    List<String> spaceSplit = versionOutput.split(' ');

    List<String> version = spaceSplit[1].split('.');

    if (version[0] == '3' && int.parse(version[1]) <= 10) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkPythonInstallation(String command) async {
    final result = await Process.run(command, ['--version']);
    if (result.exitCode == 0 && validatePythonVersion(result.stdout)) {
      return true;
    }
    return false;
  }

  Future<void> installPythonWindows() async {
    // Check if Python is already installed
    if (kDebugMode) {
      print("Start python installation...");
    }
    setState(() {
      progress += 1;
    });
    setState(() {
      step = "Start python installation...";
    });
    try {
      final pythonInstallation1 = await checkPythonInstallation('python');
      if (pythonInstallation1) {
        await isarServices.addSetting(Settings()
          ..key = 'pythonCommand'
          ..value = 'python');

        setState(() {
          step = "Python is already installed.";
        });
        setState(() {
          progress += 1;
        });
        await installPythonLibs();
        return;
      } else {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;

        final pythonInstallation2 =
            await checkPythonInstallation('$appDocPath\\Python310\\python.exe');
        if (pythonInstallation2) {
          await isarServices.addSetting(Settings()
            ..key = 'pythonCommand'
            ..value = '$appDocPath\\Python310\\python.exe');

          setState(() {
            step = "Python is already installed.";
          });
          setState(() {
            progress += 1;
          });
          await installPythonLibs();
          return;
        }
      }
    } catch (e) {
      print(e);
    }
    // Download and run the Python installer
    if (kDebugMode) {
      print("Installing python..");
    }
    setState(() {
      step = "Installing python...";
    });

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    final process = await Process.start(
      'python-installer.exe',
      [
        '/quiet',
        'InstallAllUsers=1',
        'Include_test=0',
        'TargetDir=$appDocPath\\Python310'
      ],
    );

    process.stdout.transform(utf8.decoder).listen((data) {
      if (kDebugMode) {
        print(data);
      }
    });
    process.stderr.transform(utf8.decoder).listen((data) {
      if (kDebugMode) {
        print(data);
      }
    });
    final processResult = await process.exitCode;
    if (processResult == 0) {
      if (kDebugMode) {
        print('Python has been installed successfully.');
      }
      setState(() {
        step = "Python has been installed successfully.";
        progress += 1;
      });
      await isarServices.addSetting(Settings()
        ..key = 'pythonCommand'
        ..value = '$appDocPath\\Python310\\python.exe');
      showAlertDialog(context);
    } else {
      if (kDebugMode) {
        print('Failed to install Python.');
      }
    }
  }

  Future<void> installPythonLibs() async {
    final setting = await isarServices.getSettingByKey('pythonCommand');
    final pythonCommand = setting.value;
    // final pythonCommand = 'python';
    if (kDebugMode) {
      print("installing Python libs...");
    }
    setState(() {
      progress += 1;
    });
    setState(() {
      step = "installing Python libs...";
    });

    List<String> libs = [
      'flask',
      'torch',
      'torchvision',
      'torchaudio',
      'opencv-python',
      'pandas',
      'psutil',
      'pyyaml',
      'tqdm',
      'matplotlib',
      'seaborn',
      'ultralytics'
    ];

    final installedLibs = <String, bool>{};
    for (final lib in libs) {
      final process = await Process.start(
        pythonCommand,
        ['-m', 'pip', 'show', lib],
      );
      process.stdout.listen((data) {
        if (kDebugMode) {
          print(utf8.decode(data));
        }
        setState(() {
          step = utf8.decode(data);
        });
      });
      final exitCode = await process.exitCode;
      installedLibs[lib] = exitCode == 0;
    }

    final libsToInstall = installedLibs.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();
    if (libsToInstall.isEmpty) {
      if (kDebugMode) {
        print("All Python libs are already installed.");
      }

      completeSetup();

      setState(() {
        step = "All Python libs are already installed.";
      });
      setState(() {
        progress += 1;
      });
      return;
    }

    final process = await Process.start(
      pythonCommand,
      ['-m', 'pip', 'install', ...libsToInstall],
    );
    process.stdout.transform(utf8.decoder).listen((data) {
      if (kDebugMode) {
        print(data);
      }
      setState(() {
        step = data;
      });
    });
    process.stderr.transform(utf8.decoder).listen((data) {
      if (kDebugMode) {
        print(data);
      }
      setState(() {
        step = data;
      });
    });
    final exitCode = await process.exitCode;
    if (exitCode == 0) {
      completeSetup();
    }
    if (kDebugMode) {
      print("finished installing Python libs with exit code $exitCode");
    }
    setState(() {
      step = "finished installing Python libs";
    });
    setState(() {
      progress += 1;
    });
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows) {
      installPythonWindows();
    } else if (Platform.isMacOS) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          height: 450,
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
                    "Setup",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Setup has begun. This may take a few minutes, please wait...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    step.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text("${(progress / 4) * 100}%"),
                  ),
                  LinearPercentIndicator(
                    width: 350,
                    lineHeight: 9.0,
                    animation: true,
                    animateFromLastPercent: true,
                    animationDuration: 3000,
                    barRadius: const Radius.circular(10.0),
                    percent: progress / 4,
                    backgroundColor: const Color.fromARGB(255, 87, 87, 87),
                    progressColor: Colors.amber,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
