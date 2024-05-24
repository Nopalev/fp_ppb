import 'dart:math';
import 'package:dice_icons/dice_icons.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb/component/finished_game_dialog.dart';
import 'package:fp_ppb/component/floating_action_button.dart';
import 'package:fp_ppb/component/game_board.dart';
import 'package:fp_ppb/component/medal.dart';
import 'package:fp_ppb/component/player_piece.dart';
import 'package:fp_ppb/component/roll_dice_dialog.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool disableDice = false;
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

  List<String> players = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4'
  ];

  List<int> positions = [
    0,
    0,
    0,
    0
  ];

  List<String> rank = [];

  int turn = 0;

  @override
  void initState() {
    super.initState();
    snake = vortices.map((key, value) => MapEntry(value, key));
    ladder = vortices;
  }

  int nextTurn(int from){
    from = (from + 1) % 4;
    while(positions[from] == -1){
      from = (from + 1) % 4;
    }
    return from;
  }

  void rollDice() async {
    setState(() {
      disableDice = true;
    });

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
      if(positions[turn] == 80){
        setState(() {
          positions[turn] = -1;
          rank.add(players[turn]);
        });
      }
      if(positions[turn] == -1){
        break;
      }
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

    if(rank.length == 3){
      setState(() {
        turn = nextTurn(turn);
        rank.add(players[turn]);
      });
      await Future.delayed(const Duration(milliseconds: 750));
      if(mounted){
        showDialog(
            context: context,
            builder: (context){
              return FinishedGameDialog(
                rank: rank
              );
            }
        );
      }
    }

    setState(() {
      playerPieces[turn] = PlayerPiece(
        number: turn + 1,
        size: 50.0,
        highlighted: false,
        withNumber: true,
      );
      turn = nextTurn(turn);
      playerPieces[turn] = PlayerPiece(
        number: turn + 1,
        size: 50.0,
        highlighted: true,
        withNumber: true,
      );
      disableDice = false;
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Medal(rank: 1),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      (rank.isEmpty) ? '1st: ----' : '1st: ${rank[0]}'
                    ),
                  ),
                  Medal(rank: 2),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      (rank.length < 2) ? '2nd: ----' : '2nd: ${rank[1]}'
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Medal(rank: 3),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      (rank.length < 3) ? '3rd: ----' : '3rd: ${rank[2]}'
                    ),
                  ),
                  Medal(rank: 4),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      (rank.length < 4) ? '4th: ----' : '4th: ${rank[3]}'
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
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
                positions[1] += 1;
                positions[2] += 1;
                positions[3] += 1;
              });
            },
            icon: const Icon(
              Icons.question_mark
            )
          ),
          CustomFAB(
            heroTag: 'dice',
            onPressed: disableDice ? null : rollDice,
            icon: const Icon(
              DiceIcons.dice3
            )
          )
        ],
      ),
    );
  }
}
