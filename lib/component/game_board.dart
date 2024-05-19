import 'package:flutter/material.dart';
import 'package:fp_ppb/component/game_tile.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<Widget> gridTiles = [];

  @override
  Widget build(BuildContext context) {
    for(int i = 1; i <= 80; i++){
      int number = 0;
      if(((i - 1) ~/ 8) % 2 == 1){
        number = ((9 - ((i - 1) ~/ 8)) * 8);
        number += ((i % 8) == 0) ? 8 : (i % 8);
      }
      else{
        number = 81-i;
      }
      gridTiles.add(
        GameTile(
          number: number,
        )
      );
    }

    return GridView.count(
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      crossAxisCount: 8,
      padding: EdgeInsets.zero,
      children: gridTiles,
    );
  }
}
