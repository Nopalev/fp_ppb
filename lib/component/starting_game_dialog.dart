import 'package:flutter/material.dart';

class StartingGameDialog extends StatelessWidget {
  final List<void Function()> onPresseds;
  final List<String> buttonNames;
  const StartingGameDialog({
    super.key,
    required this.onPresseds,
    required this.buttonNames
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: onPresseds[0],
              child: Text(
                buttonNames[0],
                style: const TextStyle(
                  color: Colors.blue
                ),
              )
            ),
            TextButton(
              onPressed: onPresseds[1],
              child: Text(
                buttonNames[1],
                style: const TextStyle(
                    color: Colors.blue
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
