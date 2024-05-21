import 'package:flutter/material.dart';

class PlayerPiece extends StatelessWidget {
  final int number;
  final double size;
  final bool highlighted;
  final bool withNumber;
  PlayerPiece({
    super.key,
    required this.number,
    required this.size,
    required this.highlighted,
    required this.withNumber
  });

  final List<Color> colors = [
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.yellow.shade200,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (highlighted) ? colors[number + 4 - 1] : colors[number - 1],
        border: Border.all(
          color: Colors.black,
          width: size/20,
        ),
      ),
      child: (withNumber) ?
      Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: size / 3,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
      ) : null,
    )
    ;
  }
}
