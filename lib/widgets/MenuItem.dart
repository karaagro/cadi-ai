import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function changeTab;

  const MenuItem(this.title, this.isSelected, this.changeTab, {super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => changeTab(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: isSelected
              ? BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  border: const Border(
                      left: BorderSide(color: Colors.amber, width: 4)))
              : null,
          child: Text(
            title.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}