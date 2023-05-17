import 'package:flutter/material.dart';
import 'package:cadi_ai/widgets/testAnimation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ScanProgress extends StatefulWidget {
  final double percentage;
  ScanProgress({required this.percentage});

  @override
  State<ScanProgress> createState() => _ScanProgressState();
}

class _ScanProgressState extends State<ScanProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 28.0,
            lineWidth: 4.0,
            animation: true,
            animateFromLastPercent: true,
            percent: (widget.percentage / 100),
            center: Text("${widget.percentage.toStringAsFixed(1)}%"),
            progressColor: Colors.yellow,
          ),
          SizedBox(
            height: 8,
          ),
          textAnimation(
            controller: _controller,
            text: "Please wait. running tests...",
            font_size: 11,
          ),
        ],
      ),
    );
  }
}
