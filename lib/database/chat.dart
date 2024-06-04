import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_ppb/model/chat.dart';

class ChatDatabase {
//   get collection of chat
  final CollectionReference chat =
      FirebaseFirestore.instance.collection('chat');

// CREATE
  // Future<void> createRoomChat(String idGame) {
  //   return chat.doc(idGame).set({
  //     'messages': []
  //   });
  // }
//  Check room chat sudah ada atau belum dengan id game
  // Future<bool> checkRoomChatExist(String idGame) async {
  //   try {
  //     DocumentSnapshot doc = await chat.doc(idGame).get();
  //     return doc.exists;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
// UPDATE array tambah maps untuk message
  Future<void> sendMsg(String idGame, String message) async {
    // username
    final String currentUsername = FirebaseAuth.instance.currentUser!.uid.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(username: currentUsername, message: message, timestamp: timestamp);
    
    await chat.doc(idGame).collection('messages').add(newMessage.toMap());
  }

// READ
  Stream<QuerySnapshot> getMessages(String idGame) {
    return chat.doc(idGame).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }

// DELETE
//   Future<void> deleteChat(String docID) {
//     return notes.doc(docID).delete();
//   }
}
