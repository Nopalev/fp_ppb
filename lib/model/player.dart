import 'package:firebase_auth/firebase_auth.dart';

class Player {
  User? user;
  bool isBot;

  Player({
    required this.isBot,
    this.user
  });
}