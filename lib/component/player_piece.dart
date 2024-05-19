import 'package:flutter/material.dart';

class PlayerPiece extends StatefulWidget {
  final int number;
  final double size;
  const PlayerPiece({
    super.key,
    required this.number,
    required this.size
  });

  @override
  State<PlayerPiece> createState() => _PlayerPieceState();
}

class _PlayerPieceState extends State<PlayerPiece> {
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.yellow.shade200
  ];

  bool highlighted = false;

  void toggleHighlighted(){
    setState(() {
      highlighted = !highlighted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (highlighted) ? colors[widget.number + 4 - 1] : colors[widget.number - 1],
        border: Border.all(
          color: Colors.black,
          width: 2.5,
        ),
      ),
      child: Center(
        child: Text(
          widget.number.toString(),
          style: TextStyle(
            fontSize: widget.size / 3,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
      ),
    )
    ;
  }
}
