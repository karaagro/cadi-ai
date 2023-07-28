import 'package:flutter/material.dart';
import 'package:cadi_ai/utils/strings.dart';

class ImageDialogTitle extends StatelessWidget {
  const ImageDialogTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          width: 450,
          height: 110,
          child: Column(
            children: const [
              Expanded(
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
