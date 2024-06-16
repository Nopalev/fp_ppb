import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/button.dart';
import 'package:fp_ppb/component/floating_action_button.dart';
import 'package:fp_ppb/component/square_tile.dart';
import 'package:fp_ppb/component/starting_game_dialog.dart';
import 'package:fp_ppb/component/text_field.dart';
import 'package:fp_ppb/database/game.dart';
import 'package:fp_ppb/database/player.dart';
import 'package:fp_ppb/model/game.dart';
import 'package:fp_ppb/model/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameDatabase gameDatabase = GameDatabase();
  PlayerDatabase playerDatabase = PlayerDatabase();
  DocumentReference? gameReference;
  String? waitingRoomID;
  Timer? timer;
  bool isMultiPlayer = false;
  bool isHost = false;
  bool authState(){
    return (FirebaseAuth.instance.currentUser == null) ? true : false;
  }

  void startGame() async {
    await showDialog(
      context: context,
      builder: (BuildContext buildContext){
        return StartingGameDialog(
          onPresseds: [
            () async {
              gameReference = await gameDatabase.create(
                Game(
                  host: FirebaseAuth.instance.currentUser!.uid,
                  multiplayer: false,
                  players: [
                    {
                      'id': FirebaseAuth.instance.currentUser!.uid,
                      'username': FirebaseAuth.instance.currentUser!.displayName.toString(),
                      'rank' : 0,
                      'turn' : 0,
                      'bot' : false
                    },
                    {
                      'id': 'Bot 1',
                      'username': 'Bot 1',
                      'rank' : 0,
                      'turn' : 0,
                      'bot': true
                    },
                    {
                      'id': 'Bot 2',
                      'username': 'Bot 2',
                      'rank' : 0,
                      'turn' : 0,
                      'bot': true
                    },
                    {
                      'id': 'Bot 3',
                      'username': 'Bot 3',
                      'rank' : 0,
                      'turn' : 0,
                      'bot': true
                    },
                  ],
                )
              );
              Player player = await playerDatabase.getPlayer(FirebaseAuth.instance.currentUser!.uid);
              player.setCurrentGame(gameReference!.id);
              await playerDatabase.update(player);
              if(mounted){
                Navigator.pushReplacementNamed(context, '/game');
              }
            },
            (){
              setState(() {
                isMultiPlayer = true;
              });
              Navigator.pop(buildContext);
            }
          ],
          buttonNames: const ['Single Player', 'Multi Player']
        );
      }
    );
    if(isMultiPlayer && mounted){
      await showDialog(
        context: context,
        builder: (BuildContext buildContext){
          return StartingGameDialog(
            onPresseds: [
              () async {
                setState(() {
                  isHost = true;
                });
                gameReference = await gameDatabase.create(
                  Game(
                    host: FirebaseAuth.instance.currentUser!.uid,
                    multiplayer: false,
                    players: [
                      {
                        'id': FirebaseAuth.instance.currentUser!.uid,
                        'username': FirebaseAuth.instance.currentUser!.displayName.toString(),
                        'rank' : 0,
                        'turn' : 0,
                        'bot' : false
                      }
                    ],
                  )
                );
                Player player = await playerDatabase.getPlayer(FirebaseAuth.instance.currentUser!.uid);
                player.setCurrentGame(gameReference!.id);
                await playerDatabase.update(player);
                if(buildContext.mounted){
                  Navigator.pop(buildContext);
                }
              },
              (){
                Navigator.pop(buildContext);
              }
            ],
            buttonNames: const ['Create New', 'Join Existing']
          );
        }
      );
      if(mounted && isHost){
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext buildContext){
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Press the button below to start the game',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The game code is: \n${gameReference!.id}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: (){
                              Clipboard.setData(ClipboardData(text: gameReference!.id));
                            },
                            child: const Icon(Icons.copy)
                        ),
                        CustomFAB(
                          heroTag: 'start',
                          onPressed: () async {
                            Game game = await gameDatabase.getGame(gameReference!.id);
                            int playerCount = game.players.length;
                            for(int i = game.players.length; i < 4; i++){
                              game.addPlayer({
                                'id': 'Bot ${1+(i-playerCount)}',
                                'username': 'Bot ${1+(i-playerCount)}',
                                'rank' : 0,
                                'turn' : 0,
                                'bot' : true
                              });
                            }
                            await gameDatabase.update(gameReference!.id, game);
                            if(mounted){
                              Navigator.pushReplacementNamed(context, '/game');
                            }
                          },
                          icon: const Icon(Icons.check)
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
      else if(mounted){
        await showDialog(
          context: context,
          builder: (BuildContext buildContext){
            TextEditingController textEditingController = TextEditingController();
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Insert a game code ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CustomTextField(
                        controller: textEditingController,
                        hintText: 'Enter the game code'
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomFAB(
                        heroTag: 'submit',
                        onPressed: () async {
                          String gameID = textEditingController.text;
                          Game game = await gameDatabase.getGame(gameID);

                          game.addPlayer({
                            'id': FirebaseAuth.instance.currentUser!.uid,
                            'username': FirebaseAuth.instance.currentUser!.displayName.toString(),
                            'rank' : 0,
                            'turn' : 0,
                            'bot' : false
                          });

                          gameDatabase.update(gameID, game);

                          Player player = await playerDatabase.getPlayer(FirebaseAuth.instance.currentUser!.uid);
                          player.setCurrentGame(gameID);
                          await playerDatabase.update(player);
                          if(mounted){
                            Navigator.pushReplacementNamed(context, '/game');
                          }
                        },
                        icon: const Icon(Icons.input)
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            );
          }
        );
      }
      setState(() {
        isMultiPlayer = false;
        isHost = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Snake & Ladder',
        actions: (!authState()) ? [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(
              Icons.person
            )
          )
        ] : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  const SquareTile(
                    imagePath: 'lib/assets/logo.png',
                    size: 160,
                  ),
                  const SizedBox(height: 20),
                  (authState()) ? const Button(
                    onTap: null,
                    childText: 'Please log in first'
                  ) : Button(
                      onTap: startGame,
                      childText: 'Play'
                  ),
                  const SizedBox(height: 20),
                  (authState()) ? Button(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/login');
                      },
                      childText: 'Log In'
                  ) : Button(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        setState(() {});
                      },
                      childText: 'Log Out'
                  ),
                  const SizedBox(height: 20),
                  Button(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/how_to_play');
                      },
                      childText: 'How To Play'
                  ),
                  const SizedBox(height: 20),
                  Button(
                    onTap: (){},
                    childText: 'Statistic'
                  ),
                  const SizedBox(height: 20),
                  Button(
                    onTap: () async {
                      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    },
                    childText: 'Exit',
                    color: Colors.redAccent,
                  )
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}
