import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OwnMsgCard extends StatefulWidget {
  final String message;
  final String timestamp;

  const OwnMsgCard({
    Key? key,
    required this.message,
    required this.timestamp
  }) : super(key: key);

  @override
  State<OwnMsgCard> createState() => _OwnMsgCardState();
}

class _OwnMsgCardState extends State<OwnMsgCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xFF3C0753),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                  // MESSAGE
                  padding: EdgeInsets.fromLTRB(10, 5, 40, 20),
                  child: Text(
                    widget.message,
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
