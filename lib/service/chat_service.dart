import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
//   get collection of notes
  final CollectionReference chat =
      FirebaseFirestore.instance.collection('chat');

// CREATE
  Future<void> addMsg(String msg) {
    return chat.add({
      // 'username':
      'message': msg,
      'timestamp': Timestamp.now(),
    });
  }

// READ
//   Stream<QuerySnapshot> getChat() {
//     final notesStream =
//         notes.orderBy('timestamp', descending: true).snapshots();
//     return notesStream;
//   }

// UPDATE
//   Future<void> updateChat(String docID, String newNote) {
//     return notes.doc(docID).update({
//       'note': newNote,
//       'timestamp': Timestamp.now(),
//     });
//   }

// DELETE
//   Future<void> deleteChat(String docID) {
//     return notes.doc(docID).delete();
//   }
}
