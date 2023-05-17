import 'package:flutter/material.dart';
import 'package:cadi_ai/Utils/strings.dart';

class ImageDialogTitle extends StatelessWidget {
  const ImageDialogTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          width: 450,
          height: 100,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "0",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "0.5",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "1",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  )),
              Row(
                children: [
                  SizedBox(
                      width: 225,
                      height: 5,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(3),
                                topLeft: Radius.circular(3))),
                      )),
                  SizedBox(
                    width: 225,
                    height: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(3),
                              topRight: Radius.circular(3))),
                    ),
                  )
                ],
              ),
              const Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        CONFIDENCE_VALUES_EXPLAINER,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      )))
            ],
          ))
    ]);
  }
}
