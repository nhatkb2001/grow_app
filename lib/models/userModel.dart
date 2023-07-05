// import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ffi';

class UserModel {
  final String userId;
  final String email;
  final String name;
  final String job;
  final String dob;
  final String avatar;
  final String phonenumber;
  final List projectsList;
  final List tasksList;
  final List messagesList;
  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.job,
    required this.dob,
    required this.avatar,
    required this.phonenumber,
    required this.projectsList,
    required this.tasksList,
    required this.messagesList,
  });

  factory UserModel.fromDocument(Map<String, dynamic> doc) {
    return UserModel(
        userId: doc['userId'],
        email: doc['email'],
        name: doc['name'],
        job: doc['job'],
        dob: doc['dob'],
        avatar: doc['avatar'],
        phonenumber: doc['phonenumber'],
        projectsList: doc['projectsList'],
        messagesList: doc["messagesList"],
        tasksList: doc['tasksList']);
  }
}
