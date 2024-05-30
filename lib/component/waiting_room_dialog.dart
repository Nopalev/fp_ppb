import 'package:flutter/material.dart';
import 'package:fp_ppb/component/floating_action_button.dart';

class WaitingRoomDialog extends StatelessWidget {
  const WaitingRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Searching your opponents',
        textAlign: TextAlign.center,
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator()
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        CustomFAB(
          heroTag: 'closeDialog',
          icon: const Icon(
              Icons.close
          ),
          onPressed: () { Navigator.of(context).pop(); },
        ),
      ],
    );
  }
}
