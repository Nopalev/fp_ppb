import 'package:flutter/material.dart';

class GameTile extends StatefulWidget {
  final Color? color;
  final int number;
  const GameTile({
    super.key,
    required this.number,
    this.color
  });

  @override
  State<GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: widget.color ?? Theme.of(context).highlightColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Text(
          widget.number.toString(),
          style: const TextStyle(
            fontSize: 10
          ),
        ),
      ),
    );
  }
}
