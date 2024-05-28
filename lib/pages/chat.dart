import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/own_msg_card.dart';
import 'package:fp_ppb/component/reply_msg_card.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'Chat'),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  OwnMsgCard(message: "Halo Broo"),
                  ReplyMsgCard(username: "ino",message: "Halooo"),
                  ReplyMsgCard(username: "gus",message: "Ya halo"),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 55,
                      child: Card(
                        margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message...",
                              prefixIcon: IconButton(
                                icon: Icon(Icons.emoji_emotions),
                                onPressed: () {},
                              ),
                              contentPadding: EdgeInsets.all(5)),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0XFFC738BD),
                        child: Icon(
                          Icons.send_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
