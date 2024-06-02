import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/button.dart';
import 'package:fp_ppb/component/square_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool authState(){
    return (FirebaseAuth.instance.currentUser == null) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Snake & Ladder'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Expanded(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const SquareTile(
                  imagePath: 'lib/assets/logo.png',
                  size: 160,
                ),
                const SizedBox(height: 30),
                (authState()) ? const Button(
                  onTap: null,
                  childText: 'Please log in first'
                ) : Button(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/game');
                    },
                    childText: 'Play'
                ),
                const SizedBox(height: 30),
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
                const SizedBox(height: 30),
                Button(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/how_to_play');
                    },
                    childText: 'How To Play'
                ),
                const SizedBox(height: 30),
                Button(
                  onTap: (){},
                  childText: 'Statistic'
                ),
                const SizedBox(height: 30),
                Button(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/chat');
                    },
                    childText: 'Chat'
                ),
                const SizedBox(height: 30),
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
      ),
    );
  }
}
