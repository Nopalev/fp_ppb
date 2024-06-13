import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_ppb/model/chat.dart';

class ChatDatabase {
//   get collection of chat
  final CollectionReference chat =
      FirebaseFirestore.instance.collection('chat');

// Send message
  Future<void> sendMsg(String idGame, String message) async {
    // username
    final String currentId = FirebaseAuth.instance.currentUser!.uid.toString();
    final String currentUsername = FirebaseAuth.instance.currentUser!.displayName.toString();
    final Timestamp timestamp = Timestamp.now();

    if (currentUsername.isNotEmpty) {
      Message newMessage = Message(
          username: currentUsername, message: message, timestamp: timestamp);
      await chat.doc(idGame).collection('messages').add(newMessage.toMap());
    } else {
      Message newMessage = Message(
          username: currentId, message: message, timestamp: timestamp);
      await chat.doc(idGame).collection('messages').add(newMessage.toMap());
    }
  }

// READ message
  Stream<QuerySnapshot> getMessages(String idGame) {
    return chat
        .doc(idGame)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

// DELETE message
  Future<void> deleteMessage(String idGame, String messageId) async {
    // return notes.doc(docID).delete();
    return await chat
        .doc(idGame)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

// UPDATE message
  Future<void> updateMessage(
      String idGame, String messageId, String updatedMsg) async {
    // return notes.doc(docID).delete();
    return await chat
        .doc(idGame)
        .collection('messages')
        .doc(messageId)
        .update({'message': updatedMsg});
  }
}
