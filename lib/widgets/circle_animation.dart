import 'package:flutter/material.dart';

class CircleAnimationWidget extends StatefulWidget {
  const CircleAnimationWidget({super.key, required this.child});
  final Widget child;

  @override
  State<CircleAnimationWidget> createState() => _CircleAnimationWidgetState();
}

class _CircleAnimationWidgetState extends State<CircleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000));
    controller.forward();
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: widget.child,);
  }
}
