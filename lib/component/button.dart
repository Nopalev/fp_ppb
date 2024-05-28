import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function()? onTap;
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
        width: 150,
        decoration: BoxDecoration(
          color: (onTap == null) ? Theme.of(context).disabledColor : Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Center(
          child: Text(
            childText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ?? ((onTap == null) ? Colors.blue.shade900 : Colors.blueAccent)
            ),
          ),
        ),
      ),
    );
  }
}
