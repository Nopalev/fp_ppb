import 'package:flutter/material.dart';
import 'package:fp_ppb/pages/game.dart';
import 'package:fp_ppb/pages/home.dart';
import 'package:fp_ppb/pages/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fp_ppb/pages/how_to_play.dart';
import 'package:fp_ppb/pages/login.dart';
import 'package:fp_ppb/pages/register.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Map<String, Widget Function(BuildContext)> routes = {
    '/home' : (context) => const HomePage(),
    '/game' : (context) => const GamePage(),
    '/chat' : (context) => const Chat(),
    '/login' : (context) => const LoginPage(),
    '/register' : (context) => const RegisterPage(),
    '/how_to_play' : (context) => const HowToPlayPage()
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      routes: routes,
      initialRoute: '/login',
    );
  }
}