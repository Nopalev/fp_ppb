import 'package:flutter/material.dart';
import 'package:fp_ppb/component/game_tile.dart';
import 'package:fp_ppb/component/player_piece.dart';

class GameBoard extends StatelessWidget {
  final List<int> positions;
  final Map<int, int> vortices;
  GameBoard({
    super.key,
    required this.positions,
    required this.vortices
  });

  final List<Widget> gridTiles = [];

  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow
  ];

  final Map<int, Color> vorticesColor = {};

  final List<Widget> playerPieces = [
    PlayerPiece(
      number: 1,
      size: 10.0,
      highlighted: true,
      withNumber: false,
    ),
    PlayerPiece(
      number: 2,
      size: 10.0,
      highlighted: true,
      withNumber: false,
    ),
    PlayerPiece(
      number: 3,
      size: 10.0,
      highlighted: true,
      withNumber: false,
    ),
    PlayerPiece(
      number: 4,
      size: 10.0,
      highlighted: true,
      withNumber: false,
    )
  ];

  int positionToIndex(int position){
    int res = 80 - position;
    if((res ~/ 8) % 2 == 1){
      int temp = (((res  ~/ 8)) * 8) - 1;
      if(position % 8 != 0){
        return temp + (position % 8);
      }
      else{
        return temp + (position % 8) + 8;
      }
    }
    else {
      return res;
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    for(var element in vortices.entries){
      vorticesColor[element.key] = colors[index];
      vorticesColor[element.value] = colors[index];
      index++;
    }

    for(int i = 1; i <= 80; i++){
      int number = 0;
      if(((i - 1) ~/ 8) % 2 == 1){
        number = ((9 - ((i - 1) ~/ 8)) * 8);
        number += ((i % 8) == 0) ? 8 : (i % 8);
      }
      else{
        number = 81-i;
      }
      if(vorticesColor.containsKey(number)){
        gridTiles.add(
          GameTile(
            number: number.toString(),
            playerPieces: const [],
            color: vorticesColor[number],
          )
        );
      }
      else {
        gridTiles.add(
          GameTile(
            number: number.toString(),
            playerPieces: const [],
          )
        );
      }
    }

    Map<int, List<Widget>> playerPerPosition = {};

    for(int i=0; i<positions.length; i++){
      if(positions[i] != 0) {
        playerPerPosition[positions[i]] = [];
      }
    }

    for(int i=0; i<positions.length; i++){
      if(positions[i] != 0) {
        playerPerPosition[positions[i]]!.add(playerPieces[i]);
      }
    }

    for(var temp in playerPerPosition.keys){
      if(vorticesColor.containsKey(temp)) {
        gridTiles[positionToIndex(temp)] = GameTile(
          number: temp.toString(),
          playerPieces: playerPerPosition[temp]!,
          color: vorticesColor[temp],
        );
      }
      else{
        gridTiles[positionToIndex(temp)] = GameTile(
          number: temp.toString(),
          playerPieces: playerPerPosition[temp]!,
        );
      }
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
