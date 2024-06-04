import 'package:flutter/material.dart';

class GreetingDialog extends StatelessWidget {
  final int turn;
  const GreetingDialog({
    super.key,
    required this.turn
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Welcome to the game',
        textAlign: TextAlign.center,
      ),
      content: Text(
        'You are player $turn',
        textAlign: TextAlign.center,
      )
    );
  }
}
