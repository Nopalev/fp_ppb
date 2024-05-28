import 'package:dice_icons/dice_icons.dart';
import 'package:flutter/material.dart';

class RollDIceDialog extends StatefulWidget {
  final int selectedDice;
  const RollDIceDialog({
    super.key,
    required this.selectedDice
  });

  @override
  State<RollDIceDialog> createState() => _RollDIceDialogState();
}

class _RollDIceDialogState extends State<RollDIceDialog> {
  List<IconData> dices = [
    DiceIcons.dice1,
    DiceIcons.dice2,
    DiceIcons.dice3,
    DiceIcons.dice4,
    DiceIcons.dice5,
    DiceIcons.dice6
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 10.0,
      shadowColor: Colors.blueAccent.shade100,
      content: Icon(
        dices[widget.selectedDice],
        size: 150.0,
        color: Colors.blueAccent,
      )
    );
  }
}
