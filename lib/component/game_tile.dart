import 'package:flutter/material.dart';

class GameTile extends StatelessWidget {
  final Color? color;
  final String number;
  final List<Widget> playerPieces;
  const GameTile({
    super.key,
    required this.number,
    this.color,
    required this.playerPieces
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = List.from(playerPieces);
    widgets.insert(0,
      Text(
        number,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: (color != null) ? Colors.black87 : Colors.white70
        ),
        textAlign: TextAlign.center,
      )
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color ?? Theme.of(context).highlightColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: widgets,
        ),
      ),
    );
  }
}
