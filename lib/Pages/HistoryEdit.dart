import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/services/isar_services.dart';
import 'package:cadi_ai/widgets/DeseaseNameCard.dart';
import 'package:cadi_ai/widgets/HistoryDetail.dart';
import 'package:cadi_ai/widgets/snackbars.dart';

class HistoryEdit extends StatefulWidget {
  const HistoryEdit({Key? key}) : super(key: key);

  @override
  State<HistoryEdit> createState() => _HistoryEditState();
}

class _HistoryEditState extends State<HistoryEdit> {
  IsarServices isarService = IsarServices();
  TextEditingController myController = TextEditingController();
  bool editName = false;

  void deleteDeviceImages(int id) {
    isarService.deleteImagesForHistory(id);
    showSimpleSnackBar(
        context: context,
        message: "Device images deleted successfully",
        bgColor: Colors.green);
  }

  showDeleteAlertDialog(BuildContext context, int id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(color: Colors.amber)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Delete", style: TextStyle(color: Colors.amber)),
      onPressed: () async {
        try {
          deleteDeviceImages(id);
          Navigator.pop(context);
        } catch (e) {
          showSimpleSnackBar(
              context: context,
              message: "failed to delete images",
              bgColor: Colors.red);
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: const Text(
          "Are you sure you want to delete device images?\nImages deleted cannot be recovered"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        builder: (MainController controller) => Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                    padding: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            editName
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        height: 35,
                                        child: TextField(
                                          style: TextStyle(fontSize: 14),
                                          controller: myController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 6.0,
                                                    horizontal: 8.0),
                                            hintText: 'Enter new name',
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 15)),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white24)),
                                        onPressed: () {
                                          setState(() {
                                            editName = false;
                                            print(myController.text);
                                            // Update Scan name
                                            var history = controller
                                                .appState.selectedHistory;
                                            history.scanName =
                                                myController.text.toString();
                                            isarService.updateHistory(history);
                                          });
                                        },
                                        child: const Text(
                                          'Edit',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        controller
                                            .appState.selectedHistory.scanName,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w100),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              myController.text = controller
                                                  .appState
                                                  .selectedHistory
                                                  .scanName;
                                              editName = true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            size: 20,
                                          )),
                                    ],
                                  ),
                            DeseaseNameCard(
                                name: "Abiotic",
                                number: controller
                                    .appState.selectedHistory.totalAbiotic
                                    .toString()),
                            DeseaseNameCard(
                                name: "Deseased",
                                number: controller
                                    .appState.selectedHistory.totalDiseased),
                            Text(
                              controller.appState.selectedHistory.timestamp
                                  .toString()
                                  .split(".")[0],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            HistoryDetail(
                              name: "Device images",
                              icon: Icons.folder,
                              onChange: () {
                                showDeleteAlertDialog(
                                    context,
                                    controller.appState.selectedHistory.id ??
                                        0);
                              },
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ));
  }
}
