import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import others
import 'dart:async';

import 'package:grow_app/models/projectModel.dart';

FirebaseAuth auth = FirebaseAuth.instance;
User? user = FirebaseAuth.instance.currentUser;
final userid = user?.uid.toString();
String? uid = userid;
List projectIds = [];
List projectsDataList = [];
List<Project> projectTodoList = [];
List<Project> projectDoneList = [];
List<Project> projectPendingList = [];
late Project project = Project(
  background: '',
  deadline: '',
  description: '',
  owner: '',
  progress: '',
  projectId: '',
  quantityTask: '',
  name: '',
  status: '',
  assigned: [],
);

List<Map<String, dynamic>?> projects = [];

//  Future getProjectTodoList() async {
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(uid)
//         .snapshots()
//         .listen((value) {
//       projectIds = value.data()!["projectsList"];
//       print(projectIds);
//       FirebaseFirestore.instance
//           .collection("projects")
//           .where("status", isEqualTo: 'todo')
//           .snapshots()
//           .listen((value) {
//         print('getProjectsIdList');
//         value.docs.forEach((element) {
//           if (projectIds.contains(element.data()['projectId'] as String)) {
//             projectTodoList.add(Project.fromDocument(element.data()));
//           }
//         });
//         print(projectTodoList.length);
//       });
//       setState(() {});
//     });
//   }