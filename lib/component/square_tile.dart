import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String? imagePath;
  final double? size;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).shadowColor
          ),
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).highlightColor
      ),
      child: Image.asset(
        imagePath.toString(),
        height: size,
        width: size,
      ),
    );
  }
}