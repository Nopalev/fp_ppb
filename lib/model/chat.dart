import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String username;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.username,
    required this.message,
    required this.timestamp,
  });

  // Message.fromJson(Map<String, dynamic> json){
  //   username = json['username'],
  // }

  Map<String, dynamic> toMap(){
    return{
      'username': username,
      'message': message,
      'timestamp': timestamp
    };
  }
}