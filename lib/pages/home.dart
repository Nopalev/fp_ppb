import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/button.dart';
import 'package:fp_ppb/component/square_tile.dart';
import 'package:fp_ppb/component/waiting_room_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer;
  bool authState(){
    return (FirebaseAuth.instance.currentUser == null) ? true : false;
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
          child: Column(
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
                  onTap: () async {
                    await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext buildContext){
                        timer = Timer(const Duration(seconds: 5), () {
                          Navigator.pushNamed(context, '/game');
                        });
                        return const WaitingRoomDialog();
                      }
                    ).then((value) {
                      if(timer!.isActive){
                        timer!.cancel();
                      }
                    });
                    // Navigator.pop(context);
                    // Navigator.pushReplacementNamed(context, '/game');
                  },
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
        ),
      ),
    );
  }
}
