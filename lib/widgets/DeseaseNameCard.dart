import 'package:flutter/material.dart';

class DeseaseNameCard extends StatelessWidget {
  final name;
  final number;
  const DeseaseNameCard({super.key, required this.name, required this.number});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        color: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [Text(number.toString()), Text(name.toString())],
          ),
        ),
      ),
    );
  }
}
