import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cadi_ai/entities/history.dart';
import 'package:cadi_ai/services/isar_services.dart';

class HistoryList extends StatelessWidget {
  HistoryList({Key? key, required this.searchQuery}) : super(key: key);

  final String searchQuery;
  final List<Image>? scanImageHistory = [];
  final IsarServices isarService = IsarServices();
  final MainController mainController = Get.find<MainController>();

  Future<List<History>> readScanHistory() async {
    return await isarService.getAllHistory();
  }

  void initializeHistoryRelatedStateValues(List<History>? history) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainController.updateTotalCropStress(history);
      mainController.updateTotalDiagnosis(history);
    });
  }

  void onHistoryItemSelected(MainController controller, History history) async {
    controller.updateSelectedHistory(history);
    controller.updateHistoryStackIndex(1);
  }

  void onEditHistoryItemSelected(
      MainController controller, History history) async {
    controller.updateSelectedHistory(history);
    controller.updateHistoryStackIndex(2);
  }

  onDeleteHistoryItemSelected(
      BuildContext context, MainController controller, History history) {
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
          await isarService.deleteScan(history);
          controller.updateApplicationState();
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } catch (e) {
          showSimpleSnackBar(
              context: context,
              message: "Failed to delete scan",
              bgColor: Colors.red);
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: const Text(
          "Are you sure you want to delete this scan?\nThis operation is not reversible"),
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

  List<History> _getFilteredHistory(List<History> historys) {
    return historys
        .where((element) =>
            element.scanName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            (element.totalAbiotic > 0 &&
                "abiotic".contains(searchQuery.toLowerCase())) ||
            (element.totalPest > 0 &&
                "pest".contains(searchQuery.toLowerCase())) ||
            (element.totalDiseased > 0 &&
                "diseased".contains(searchQuery.toLowerCase())))
        .toList();
  }

  emptyHistoryFilter() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
          (searchQuery.isNotEmpty)
              ? "No history matches your search \"$searchQuery\""
              : "No history available",
          style: const TextStyle(fontSize: 20, color: Colors.grey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<History>>(
          future: readScanHistory(),
          builder: (context, AsyncSnapshot<List<History>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
            if (snapshot.hasData) {
              final filterdHistory = _getFilteredHistory(snapshot.data!);
              initializeHistoryRelatedStateValues(snapshot.data);

              return GetBuilder(builder: (MainController controller) {
                if (filterdHistory.isEmpty) {
                  return emptyHistoryFilter();
                }

                return ListView.builder(
                    itemCount: filterdHistory.length,
                    itemBuilder: (context, index) {
                      int reverseIndex = filterdHistory.length - index - 1;

                      return SizedBox(
                        width: Get.width,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              alignment: WrapAlignment.spaceAround,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Row(children: [
                                    Flexible(
                                        child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: filterdHistory[reverseIndex]
                                              .scanName
                                              .toString()),
                                    ))
                                  ]),
                                ),
                                SizedBox(
                                    width: 100,
                                    child: Card(
                                      color: Colors.white24,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                                '${filterdHistory[reverseIndex].totalDiseased}'),
                                            const Text('Diseased')
                                          ],
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                    width: 100,
                                    child: Card(
                                      color: Colors.white24,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                                '${filterdHistory[reverseIndex].totalAbiotic}'),
                                            const Text('Abiotic')
                                          ],
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                    width: 100,
                                    child: Card(
                                      color: Colors.white24,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                                '${filterdHistory[reverseIndex].totalPest}'),
                                            const Text('Pests')
                                          ],
                                        ),
                                      ),
                                    )),
                                Text(filterdHistory[reverseIndex]
                                    .timestamp
                                    .toString()
                                    .split(".")[0]),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        tooltip: 'view',
                                        onPressed: () => onHistoryItemSelected(
                                            controller,
                                            filterdHistory[reverseIndex]),
                                        icon: const Icon(Icons.remove_red_eye)),
                                    Container(
                                      width: 20,
                                    ),
                                    IconButton(
                                        tooltip: 'edit',
                                        onPressed: () {
                                          onEditHistoryItemSelected(controller,
                                              filterdHistory[reverseIndex]);
                                        },
                                        icon: const Icon(Icons.edit)),
                                    Container(
                                      width: 20,
                                    ),
                                    IconButton(
                                        tooltip: 'Delete',
                                        onPressed: () {
                                          onDeleteHistoryItemSelected(
                                              context,
                                              controller,
                                              filterdHistory[reverseIndex]);
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              });
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
