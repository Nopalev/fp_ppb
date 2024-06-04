import 'package:flutter/material.dart';
import 'dart:math';

class SetColor {
  static Color randomColor() {
    final Random number = Random();

    int red = 200 + number.nextInt(56);
    int green = 200 + number.nextInt(56);
    int blue = 200 + number.nextInt(56);

    return Color.fromARGB(255, red, green, blue);
  }
}

class ReplyMsgCard extends StatefulWidget {
  final String username;
  final String message;
  final String timestamp;

  const ReplyMsgCard({
    super.key,
    required this.username,
    required this.message,
    required this.timestamp
  }) : super(key: key);

  @override
  State<ReplyMsgCard> createState() => _ReplyMsgCardState();
}

class _ReplyMsgCardState extends State<ReplyMsgCard> {
  Color colorChatUser = SetColor.randomColor();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: const Color(0xFF35374B),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(widget.username,
                      style: TextStyle(fontSize: 14, color: colorChatUser, fontWeight: FontWeight.bold))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 40, 20),
                  child: Text(
                    widget.message,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )),
              Positioned(
                  bottom: 4,
                  right: 10,
                  child: Text(
                    widget.timestamp,
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
