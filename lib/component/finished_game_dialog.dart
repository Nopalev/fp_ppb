import 'package:flutter/material.dart';
import 'package:fp_ppb/component/medal.dart';
import 'package:fp_ppb/component/floating_action_button.dart';
import 'package:fp_ppb/component/square_tile.dart';

class FinishedGameDialog extends StatelessWidget {
  final List<String> ranks;
  final int rank;
  const FinishedGameDialog({
    super.key,
    required this.ranks,
    required this.rank
  });

  @override
  Widget build(BuildContext context) {
    String rankMessage = switch(rank){
      1 => '1st',
      2 => '2nd',
      3 => '3rd',
      4 => '4th',
      _ => ''
    };

    return AlertDialog(
      alignment: Alignment.center,
      elevation: 10.0,
      shadowColor: Colors.blueAccent.shade100,
      title: Text(
        'You finished $rankMessage',
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
                    '1st: ${ranks[0]}'
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
                    '2nd: ${ranks[1]}'
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
                    '3rd: ${ranks[2]}'
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
                    '4th: ${ranks[3]}'
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
          onPressed: () { Navigator.of(context).pushReplacementNamed('/home'); },
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
