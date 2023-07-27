import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/pages/HistoryListTabView.dart';
import 'package:cadi_ai/pages/HistoryEdit.dart';
import 'package:cadi_ai/pages/HistoryList.dart';
import 'package:cadi_ai/widgets/input_fields.dart';
import 'package:cadi_ai/utils/rate_limitters.dart' as rate_limitters;

class HistoryLayout extends StatefulWidget {
  const HistoryLayout({Key? key}) : super(key: key);

  @override
  State<HistoryLayout> createState() => _HistoryLayoutState();
}

class _HistoryLayoutState extends State<HistoryLayout> {
  String _searchText = '';

  late final _handleSearch = rate_limitters.debounce((String text) {
    setState(() {
      _searchText = text;
    });
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        builder: (MainController controller) => Scaffold(
              body: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 18, left: 20, right: 80),
                    height: 80,
                    width: Get.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 400,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  iconSize: 16,
                                  onPressed: () {
                                    if (controller.appState
                                            .selectedHistoryStackIndex ==
                                        0) {
                                      return;
                                    }
                                    controller.updateHistoryStackIndex(
                                        controller.appState
                                                .selectedHistoryStackIndex -
                                            1);
                                  },
                                  icon: Icon(Icons.adaptive.arrow_back)),
                              SizedBox(
                                width: 290,
                                height: 40,
                                child: SearchInputField(
                                  onChanged: (text) {
                                    if (controller.appState
                                            .selectedHistoryStackIndex !=
                                        0) {
                                      return;
                                    }
                                    _handleSearch(text);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                      child: IndexedStack(
                    index: controller.appState.selectedHistoryStackIndex,
                    children: [
                      HistoryList(
                        searchQuery: _searchText,
                      ),
                      HistoryListTabView(),
                      const HistoryEdit()
                    ],
                  ))
                ],
              ),
            ));
  }
}
