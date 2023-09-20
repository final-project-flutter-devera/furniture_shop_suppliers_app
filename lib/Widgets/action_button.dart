import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final void Function() onPressed;
  final List<BoxShadow> boxShadow;
  final Widget content;
  final Size size;
  final Color color;
  const ActionButton({
    super.key,
    required this.boxShadow,
    required this.content,
    this.size = const Size(double.infinity, 60),
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: boxShadow,
        ),
        child: Center(
          child: content,
        ),
      ),
    );
  }
}
