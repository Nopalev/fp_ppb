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
  List<int> players = [
    1,
    2,
    3,
    4
  ];
  List<int> positions = [
    1,
    2,
    3,
    4
  ];

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
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                verticalDirection: VerticalDirection.up,
                children: [
                  PlayerPiece(
                    number: 1,
                    size: 50.0,
                    highlighted: false,
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
                  ),
                ],
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
            heroTag: 'dice',
            onPressed: rollDice,
            icon: const Icon(
              DiceIcons.dice3
            )
          ),CustomFAB(
              heroTag: 'add',
              onPressed: (){
                setState(() {
                  positions[3] += 1;
                });
              },
              icon: const Icon(
                  Icons.add
              )
          )
        ],
      ),
    );
  }
}
