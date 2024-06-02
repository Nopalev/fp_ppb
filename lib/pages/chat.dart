import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/own_msg_card.dart';
import 'package:fp_ppb/component/reply_msg_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb/service/chat_service.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  //Firestore
  final ChatService chatService = ChatService();
  //Text Controller
  final TextEditingController msgController = TextEditingController();

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
                                onPressed: () {
                                },
                              ),
                              contentPadding: EdgeInsets.all(5)),
                          controller: msgController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: (){
                          chatService.addMsg(msgController.text);
                          msgController.clear();
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0XFFC738BD),
                          child: Icon(
                            Icons.send_sharp,
                            color: Colors.white,
                          ),
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
