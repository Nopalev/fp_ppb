import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_icons/dice_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb/component/finished_game_dialog.dart';
import 'package:fp_ppb/component/floating_action_button.dart';
import 'package:fp_ppb/component/game_board.dart';
import 'package:fp_ppb/component/medal.dart';
import 'package:fp_ppb/component/player_piece.dart';
import 'package:fp_ppb/component/roll_dice_dialog.dart';
import 'package:fp_ppb/database/game.dart';
import 'package:fp_ppb/model/game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameDatabase gameDatabase = GameDatabase();
  DocumentReference? gameReference;
  Game game = Game(
    players: [
      FirebaseAuth.instance.currentUser!.uid,
      'Bot 2',
      'Bot 3',
      'Bot 4'
    ]
  );
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

  List<int> positions = [
    0,
    0,
    0,
    0
  ];

  int turn = 0;

  void createToDB() async {
    gameReference = await gameDatabase.create(game);
  }

  @override
  void initState() {
    super.initState();
    createToDB();
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
      builder: (builderContext){
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(builderContext).pop();
        });
        return RollDIceDialog(
          selectedDice: dice
        );
      }
    );

    for(int i=0; i<=dice; i++){
      await Future.delayed(const Duration(milliseconds: 750));
      setState(() {
        positions[turn] += 1;
      });
      if(positions[turn] == 80){
        await Future.delayed(const Duration(milliseconds: 750));
        setState(() {
          positions[turn] = -1;
          game.changeRank(turn);
          gameDatabase.update(gameReference!.id, game);
        });
      }
      if(positions[turn] == -1){
        break;
      }
    }
    await Future.delayed(const Duration(milliseconds: 750));

    if(snake.containsKey(positions[turn])){
      setState(() {
        positions[turn] = snake[positions[turn]]!;
      });
    }
    else if(ladder.containsKey(positions[turn])){
      setState(() {
        positions[turn] = ladder[positions[turn]]!;
      });
    }

    if(game.rank.length == 3){
      setState(() {
        turn = nextTurn(turn);
        game.changeRank(turn);
        gameDatabase.update(gameReference!.id, game);
      });
      await Future.delayed(const Duration(milliseconds: 750));
      if(mounted){
        showDialog(
            context: context,
            builder: (context){
              return FinishedGameDialog(
                rank: game.rank
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
      if(game.players[turn] == FirebaseAuth.instance.currentUser!.uid){
        disableDice = false;
      }
    });
    if(game.players[turn].contains('Bot $turn')){
      rollDice();
    }
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
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Medal(rank: 1),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      (game.rank.isEmpty) ? '1st: ----' : '1st: ${game.rank[0]}'
                    ),
                  ),
                  Medal(rank: 2),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      (game.rank.length < 2) ? '2nd: ----' : '2nd: ${game.rank[1]}'
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
                      (game.rank.length < 3) ? '3rd: ----' : '3rd: ${game.rank[2]}'
                    ),
                  ),
                  Medal(rank: 4),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      (game.rank.length < 4) ? '4th: ----' : '4th: ${game.rank[3]}'
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
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
