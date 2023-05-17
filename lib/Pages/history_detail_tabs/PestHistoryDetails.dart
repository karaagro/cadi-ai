import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/Pages/MapDisplay.dart';
import 'package:cadi_ai/Utils/helpers.dart';
import 'package:cadi_ai/widgets/HistoryImageCardsList.dart';

class PestHistoryDetails extends StatefulWidget {
  const PestHistoryDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<PestHistoryDetails> createState() => _PestHistoryDetailsState();
}

class _PestHistoryDetailsState extends State<PestHistoryDetails> {
  int historyFlex = 100;
  int mapFlex = 200;
  int scale = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        builder: (MainController controller) => Row(
              children: [
                Expanded(
                    flex: historyFlex,
                    child: HistoryImageCardsList(
                      classFilter: PEST_FILTER,
                      scale: scale,
                    )),
                MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: GestureDetector(
                    onHorizontalDragUpdate: ((details) {
                      // print(details.delta.distance);
                      print(historyFlex - 100);
                      if (details.delta.dx < 0) {
                        print("left drag");
                        if (historyFlex > 100) {
                          setState(() {
                            historyFlex -= details.delta.distance.toInt();
                            mapFlex += details.delta.distance.toInt();
                          });
                          setState(() {
                            scale = historyFlex - 100;
                          });
                        }
                      } else if (details.delta.dx > 0) {
                        print("right drag");
                        if (mapFlex > 100) {
                          setState(() {
                            historyFlex += details.delta.distance.toInt();
                            mapFlex -= details.delta.distance.toInt();
                          });
                          setState(() {
                            scale = historyFlex;
                          });
                        }
                      }
                    }),
                    child: Container(
                      height: 40,
                      width: 10,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Expanded(
                  flex: mapFlex,
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints.expand(),
                    child: const Padding(
                        padding: EdgeInsets.only(
                            left: 0, top: 0, bottom: 0, right: 5),
                        child: MapDisplay()),
                  ),
                )
              ],
            ));
  }
}
