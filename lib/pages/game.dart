import 'dart:math';
import 'package:dice_icons/dice_icons.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb/component/floating_action_button.dart';
import 'package:fp_ppb/component/game_board.dart';
import 'package:fp_ppb/component/player_piece.dart';
import 'package:fp_ppb/component/roll_dice_dialog.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Widget> playerPieces = [
    PlayerPiece(
      number: 1,
      size: 50.0,
      highlighted: true,
      withNumber: true,
    ),
    PlayerPiece(
      number: 2,
      size: 50.0,
      highlighted: false,
      withNumber: true,
    ),
    PlayerPiece(
      number: 3,
      size: 50.0,
      highlighted: false,
      withNumber: true,
    ),
    PlayerPiece(
      number: 4,
      size: 50.0,
      highlighted: false,
      withNumber: true,
    )
  ];

  Map<int, int> vortices = {
    10: 54,
    14: 39,
    30: 67,
    51: 76,
  };

  Map<int, int> snake = {};
  Map<int, int> ladder = {};

  List<int> players = [
    1,
    2,
    3,
    4
  ];

  List<int> positions = [
    0,
    0,
    0,
    0
  ];

  int turn = 0;

  @override
  void initState() {
    super.initState();
    snake = vortices.map((key, value) => MapEntry(value, key));
    ladder = vortices;
  }

  void rollDice() async {
    int dice = Random().nextInt(6);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return RollDIceDialog(
          selectedDice: dice
        );
      }
    );

    for(int i=0; i<=dice; i++){
      setState(() {
        positions[turn] += 1;
      });
      await Future.delayed(const Duration(milliseconds: 750));
    }

    if(snake.containsKey(positions[turn])){
      setState(() {
        positions[turn] = snake[positions[turn]]!;
      });
      await Future.delayed(const Duration(milliseconds: 750));
    }
    else if(ladder.containsKey(positions[turn])){
      setState(() {
        positions[turn] = ladder[positions[turn]]!;
      });
      await Future.delayed(const Duration(milliseconds: 750));
    }

    setState(() {
      playerPieces[turn] = PlayerPiece(
        number: turn + 1,
        size: 50.0,
        highlighted: false,
        withNumber: true,
      );
      turn = (turn + 1) % 4;
      playerPieces[turn] = PlayerPiece(
        number: turn + 1,
        size: 50.0,
        highlighted: true,
        withNumber: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: const Text(
                  '00:00:000',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Expanded(
                child: GameBoard(
                  positions: positions,
                  vortices: vortices,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                verticalDirection: VerticalDirection.up,
                children: playerPieces
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomFAB(
            heroTag: 'howToPlay',
            onPressed: (){
              setState(() {
                positions[3] += 1;
              });
            },
            icon: const Icon(
              Icons.question_mark
            )
          ),
          CustomFAB(
            heroTag: 'dice',
            onPressed: rollDice,
            icon: const Icon(
              DiceIcons.dice3
            )
          )
        ],
      ),
    );
  }
}
