import 'dart:async';
import 'dart:math';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_icons/dice_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb/component/finished_game_dialog.dart';
import 'package:fp_ppb/component/floating_action_button.dart';
import 'package:fp_ppb/component/game_board.dart';
import 'package:fp_ppb/component/greeting_dialog.dart';
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
  Timer? timer;
  DocumentReference? gameReference;

  int turn = 0;
  int rank = 1;
  bool disableDice = false;
  bool gameFinished = false;
  bool suspendRollDiceDialog = false;

  Game game = Game(
    players: [
      {
        'id': FirebaseAuth.instance.currentUser!.uid,
        'username': FirebaseAuth.instance.currentUser!.displayName.toString(),
        'rank' : 0,
        'bot' : false
      },
      {
        'id': 'Bot 2',
        'username': 'Bot 2',
        'rank' : 0,
        'bot': true
      },
      {
        'id': 'Bot 3',
        'username': 'Bot 3',
        'rank' : 0,
        'bot': true
      },
      {
        'id': 'Bot 4',
        'username': 'Bot 4',
        'rank' : 0,
        'bot': true
      },
    ],
  );

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

  void initGame() async {
    gameReference = await gameDatabase.create(game);
    if(mounted){
      await showDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext){
          timer = Timer(const Duration(seconds: 2), () {
            Navigator.pop(buildContext);
          });
          return GreetingDialog(
            turn: game.playerTurn(FirebaseAuth.instance.currentUser!.uid)
          );
        }
      ).then((value) {
        if(timer!.isActive){
          timer!.cancel();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initGame();
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
    if(!suspendRollDiceDialog){
      await showDialog(
          useRootNavigator: false,
          context: context,
          barrierDismissible: false,
          builder: (buildContext) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(buildContext).pop();
            });
            return RollDIceDialog(selectedDice: dice);
          });
    }

    for(int i=0; i<=dice; i++){
      await Future.delayed(const Duration(milliseconds: 750));
      setState(() {
        positions[turn] += 1;
      });
      if(positions[turn] == 80){
        await Future.delayed(const Duration(milliseconds: 750));
        setState(() {
          positions[turn] = -1;
          game.changeRank(turn, rank);
          rank++;
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

    if(rank == 4){
      setState(() {
        gameFinished = true;
        turn = nextTurn(turn);
        positions[turn] = -1;
        game.changeRank(turn, rank);
        gameDatabase.update(gameReference!.id, game);
      });
      await Future.delayed(const Duration(milliseconds: 750));
      if(mounted){
        await showDialog(
          context: context,
          builder: (buildContext){
            return FinishedGameDialog(
              ranks: game.ranks,
              rank: game.getRank(FirebaseAuth.instance.currentUser!.uid),
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
              },
            );
          }
        );
      }
    }

    await Future.delayed(const Duration(milliseconds: 750));
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
      if(game.players[turn]['id'] == FirebaseAuth.instance.currentUser!.uid){
        disableDice = false;
      }
    });
    if(game.players[turn]['bot'] && !gameFinished){
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
                      (game.ranks.isEmpty) ? '1st: ----' : '1st: ${game.ranks[0]}'
                    ),
                  ),
                  Medal(rank: 2),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      (game.ranks.length < 2) ? '2nd: ----' : '2nd: ${game.ranks[1]}'
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
                      (game.ranks.length < 3) ? '3rd: ----' : '3rd: ${game.ranks[2]}'
                    ),
                  ),
                  Medal(rank: 4),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      (game.ranks.length < 4) ? '4th: ----' : '4th: ${game.ranks[3]}'
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
          ),
          badges.Badge(
            badgeContent: const Text('3'),
            child: CustomFAB(
              heroTag: 'chat',
              onPressed: () async {
                setState(() {
                  suspendRollDiceDialog = true;
                });
                await Navigator.pushNamed(context, '/chat', arguments: {'idGame': gameReference!.id});
                setState(() {
                  suspendRollDiceDialog = false;
                });
              },
              icon: const Icon(
                  Icons.chat
              )
            ),
          )
        ],
      ),
    );
  }
}
