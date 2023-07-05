// import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ffi';

class Message {
  final String userId1;
  final String userId2;
  final List contentList;
  final String messageId;
  final String createAt;
  final String name1;
  final String name2;
  final String background;

  Message({
    required this.contentList,
    required this.userId1,
    required this.userId2,
    required this.messageId,
    required this.createAt,
    required this.name2,
    required this.name1,
    required this.background,
  });
  factory Message.fromDocument(Map<String, dynamic> doc) {
    return Message(
        contentList: doc['contentList'],
        messageId: doc['messageId'],
        userId1: doc['userId1'],
        userId2: doc['userId2'],
        createAt: doc['timeSend'],
        background: doc['background'],
        name1: doc['name1'],
        name2: doc['name2']);
  }
}
