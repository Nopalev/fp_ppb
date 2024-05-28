import 'package:flutter/material.dart';

class OwnMsgCard extends StatefulWidget {
  final String message;
  // final String timestamp;

  const OwnMsgCard({
    super.key,
    required this.message,
    // required this.timestamp
  });

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
          color: const Color(0xFF3C0753),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                  // MESSAGE
                  padding: const EdgeInsets.fromLTRB(10, 5, 40, 20),
                  child: Text(
                    widget.message,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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
