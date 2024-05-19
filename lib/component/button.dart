import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function() onTap;
  final String childText;
  final Color? color;
  const Button({
    super.key,
    required this.onTap,
    required this.childText,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Center(
          child: Text(
            childText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.blueAccent
            ),
          ),
        ),
      ),
    );
  }
}
