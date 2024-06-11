import 'package:flutter/material.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/own_msg_card.dart';
import 'package:fp_ppb/component/reply_msg_card.dart';
import 'package:fp_ppb/database/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  //Firestore
  final ChatDatabase chatDatabase = ChatDatabase();
  //Text Controller
  final TextEditingController msgController = TextEditingController();
  // Scroll Controller
  final ScrollController _scrollController = ScrollController();

  String formatTimeStamp(Timestamp timestamp){
    DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm').format(dateTime);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String idGame = args['idGame'];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Chat'),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatDatabase.getMessages(idGame),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return const Center(child: Text("Error"),);
                }
            
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
            
                List messagesList = snapshot.data!.docs;
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    // Retrieve message data
                    Map<String, dynamic> data = messagesList[index].data();
                    final String msgId = messagesList[index].id;
                    final String username = data['username'];
                    final String text = data['message'];
                    final String timestamp = formatTimeStamp(data['timestamp']);
                    final String loginUser = FirebaseAuth.instance.currentUser!.uid.toString();
      
                    // Check if the message is sent by the current user or others
                    if (username == loginUser){
                      return OwnMsgCard(message: text, timestamp: timestamp, messageId: msgId, idGame: idGame);
                    }else{
                      return ReplyMsgCard(username: username, message: text, timestamp: timestamp);
                    }
                  },
                  shrinkWrap: true,
                );
              },
            ),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 55,
                  child: Card(
                    margin: const EdgeInsets.only(
                        left: 2, right: 2, bottom: 8),
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
                            icon: const Icon(Icons.emoji_emotions),
                            onPressed: () {},
                          ),
                          contentPadding: const EdgeInsets.all(5)),
                      controller: msgController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Kirim pesan
                      chatDatabase.sendMsg(idGame, msgController.text);
                      msgController.clear();
                    },
                    child: const CircleAvatar(
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
    );
  }
}