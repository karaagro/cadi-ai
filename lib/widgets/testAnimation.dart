import 'package:flutter/material.dart';

class textAnimation extends StatelessWidget {
  const textAnimation({
    Key? key,
    required this.text,
    required this.font_size,
    required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final String text;
  final int font_size;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeIn)),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.0)
                .chain(CurveTween(curve: Curves.easeOut)),
            weight: 1,
          ),
        ],
      ).animate(_controller),
      child: Text(
        text,
        style: TextStyle(
          fontSize: font_size.toDouble(),
          color: Colors.grey,
          fontWeight: FontWeight.normal,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
