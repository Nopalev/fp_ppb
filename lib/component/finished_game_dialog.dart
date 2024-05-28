import 'package:flutter/material.dart';
import 'package:fp_ppb/component/medal.dart';
import 'package:fp_ppb/component/floating_action_button.dart';
import 'package:fp_ppb/component/square_tile.dart';

class FinishedGameDialog extends StatelessWidget {
  final List<String> rank;
  const FinishedGameDialog({
    super.key,
    required this.rank
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 10.0,
      shadowColor: Colors.blueAccent.shade100,
      title: const Text(
        'Game is finished',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SquareTile(
            imagePath: 'lib/assets/logo.png',
            size: 160,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Medal(rank: 1),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    '1st: ${rank[0]}'
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Medal(rank: 2),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    '2nd: ${rank[1]}'
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Medal(rank: 3),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    '3rd: ${rank[2]}'
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Medal(rank: 4),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    '4th: ${rank[3]}'
                ),
              )
            ],
          ),
        ],
      ),
      actions: <Widget>[
        CustomFAB(
          heroTag: 'closeDialog',
          icon: const Icon(
              Icons.close
          ),
          onPressed: () { Navigator.of(context).popUntil(ModalRoute.withName('/home')); },
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
