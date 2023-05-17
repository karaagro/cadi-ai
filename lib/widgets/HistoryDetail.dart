import 'package:flutter/material.dart';

class HistoryDetail extends StatelessWidget {
  final name;
  final icon;
  final Function()? onChange;

  const HistoryDetail({
    Key? key,
    this.name,
    this.icon,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: Colors.white24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    name.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w200),
                  )
                ],
              ),
              TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.white24)),
                onPressed: onChange,
                child: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                ),
              )
            ],
          ),
          const Divider(
            height: 20,
          )
        ],
      ),
    );
  }
}
