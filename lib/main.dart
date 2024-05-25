import 'package:flutter/material.dart';
import 'package:fp_ppb/pages/game.dart';
import 'package:fp_ppb/pages/home.dart';
import 'package:fp_ppb/pages/chat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Map<String, Widget Function(BuildContext)> routes = {
    '/home' : (context) => const HomePage(),
    '/game' : (context) => const GamePage(),
    '/chat' : (context) => const Chat(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      routes: routes,
      initialRoute: '/chat',
    );
  }
}