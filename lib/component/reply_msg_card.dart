import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  // final String timestamp;

  const ReplyMsgCard({
    Key? key,
    required this.username,
    required this.message,
    // required this.timestamp
  }) : super(key: key);

  @override
  State<ReplyMsgCard> createState() => _ReplyMsgCardState();
}

class _ReplyMsgCardState extends State<ReplyMsgCard> {
  Color ColorChatUser = SetColor.randomColor();

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
          color: Color(0xFF35374B),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 10, top: 5),
                  child: Text(widget.username,
                      style: TextStyle(fontSize: 14, color: ColorChatUser, fontWeight: FontWeight.bold))),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 25, 40, 20),
                  child: Text(
                    widget.message,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
              Positioned(
                  bottom: 4,
                  right: 10,
                  child: Text(
                    "10:22",
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
