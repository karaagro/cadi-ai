import 'package:flutter/material.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/Pages/history_detail_tabs/AbioticHistoryDetails.dart';
import 'package:cadi_ai/Pages/history_detail_tabs/AllHistoryDetails.dart';
import 'package:cadi_ai/Pages/history_detail_tabs/DiseasedHistoryDetails.dart';
import 'package:cadi_ai/Pages/history_detail_tabs/PestHistoryDetails.dart';
import 'package:get/get.dart';

class HistoryListTabView extends StatelessWidget {
  final mainController = Get.find<MainController>();

  HistoryListTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 2,
          bottom: TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white24,
            tabs: <Widget>[
              const Tab(child: Text('All Cases')),
              Tab(
                  child: Text(
                      '${mainController.appState.selectedHistory.totalAbiotic} counts of Abiotic')),
              Tab(
                  child: Text(
                      '${mainController.appState.selectedHistory.totalDiseased} counts of Diseased')),
              Tab(
                child: Text(
                    '${mainController.appState.selectedHistory.totalPest} counts of Insect'),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            AllHistoryDetails(),
            AbioticHistoryDetails(),
            DiseasedHistoryDetails(),
            PestHistoryDetails()
          ],
        ),
      ),
    );
  }
}
