import 'package:dice_icons/dice_icons.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb/component/floating_action_button.dart';
import 'package:fp_ppb/component/game_board.dart';
import 'package:fp_ppb/component/player_piece.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  void rollDice() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(10.0),
          minScale: 0.1,
          maxScale: 3.0,
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
                const Expanded(
                  child: GameBoard()
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  verticalDirection: VerticalDirection.up,
                  children: [
                    PlayerPiece(
                      number: 1,
                      size: 50.0,
                    ),
                    PlayerPiece(
                      number: 2,
                      size: 50.0,
                    ),
                    PlayerPiece(
                      number: 3,
                      size: 50.0,
                    ),
                    PlayerPiece(
                      number: 4,
                      size: 50.0,
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
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
          )
        ],
      ),
    );
  }
}
