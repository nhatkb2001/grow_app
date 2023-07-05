import 'package:flutter/material.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/others.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow_app/models/projectModel.dart';
import 'package:grow_app/models/userModel.dart';
import 'package:grow_app/views/widget/snackBarWidget.dart';
import 'package:intl/intl.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';

class messageSearchingScreen extends StatefulWidget {
  String uid;

  messageSearchingScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _messageSearchingScreenState createState() =>
      _messageSearchingScreenState(uid);
}

class _messageSearchingScreenState extends State<messageSearchingScreen> {
  // final String? uid = controllers.currentUserId;

  String search = '';
  String uid = '';
  List projectIds = [];
  List projectIdAll = [];
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
  late UserModel user = UserModel(
      avatar: '',
      tasksList: [],
      dob: '',
      email: '',
      messagesList: [],
      name: '',
      job: '',
      phonenumber: '',
      projectsList: [],
      userId: '');
  List<UserModel> userListChoice = [];
  List<UserModel> userAllList = [];

  List<Project> projectSearchList = [];
  List<Project> projectAllList = [];

  List<UserModel> userSearchList = [];

  _messageSearchingScreenState(uid);

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');
  late String task;

  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String userName = '';
  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .listen((value) {
      setState(() {
        user = UserModel.fromDocument(value.docs.first.data());
      });
      userName = user.name;
    });
  }

  late String newMessageId;

  Future createMessage(String userIdS2, String userName2) async {
    // FirebaseFirestore.instance
    //     .collection("messages")
    //     .get()
    //     .then((value) => value.docs.forEach((element) {
    //           setState(() {
    //             if (("$userName" + "_" + "$userName2")
    //                     .contains((element.data()['name'] as String)) &&
    //                 element.data()['timeSend'] != null) {
    //               newMessageId = element.id;
    //             } else {
    FirebaseFirestore.instance
        .collection("messages")
        .add({
          'userId1': uid,
          'userId2': userIdS2,
          'name': "$userName" + "_" + "$userName2",
          'background': 'https://i.imgur.com/YtZkAbe.jpg',
          'contentList': FieldValue.arrayUnion([""]),
          'timeSend': "${DateFormat('hh:mm a').format(DateTime.now())}",
        })
        .then((value) {
          setState(() {
            FirebaseFirestore.instance
                .collection("messages")
                .doc(value.id)
                .update({
              'messageId': value.id,
            });
          });
          newMessageId = value.id;
        })
        .whenComplete(() =>
            FirebaseFirestore.instance.collection("users").doc(uid).update({
              'messagesList': FieldValue.arrayUnion([newMessageId]),
            }))
        .whenComplete(() => FirebaseFirestore.instance
                .collection("users")
                .doc(userIdS2)
                .update({
              'messagesList': FieldValue.arrayUnion([newMessageId])
            }));
  }

  searchUserByEmail(String search) async {
    FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: search)
        .get()
        .then((value) {
      setState(() {
        value.docs.forEach((element) {
          var check =
              userSearchList.where((element) => element.email == search);
          if (check.isEmpty) {
            userSearchList.add(UserModel.fromDocument(element.data()));
          } else {
            showSnackBar(context, "This email is searched ", "error");
          }
        });
        print("Nhan r nha");
        print(search);
      });
    });
  }

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundBasic), fit: BoxFit.cover),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 62),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 28),
                    alignment: Alignment.center,
                    child: Form(
                      // key: formKey,
                      child: Container(
                        width: 291,
                        height: 40,
                        padding: EdgeInsets.only(left: 2, right: 24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: purpleLight),
                        alignment: Alignment.topCenter,
                        child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: black,
                                fontWeight: FontWeight.w400),
                            controller: searchController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                searchUserByEmail(searchController.text);
                              });
                            },
                            onEditingComplete: () {
                              searchUserByEmail(searchController.text);
                            },
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                    IconButton(
                                      icon: Icon(Iconsax.search_normal_1),
                                      iconSize: 20,
                                      color: black,
                                      onPressed: () {
                                        // searchUserByEmail(search);
                                      },
                                    )
                                  ])),
                              border: InputBorder.none,
                              hintText: "Search by entering email",
                              hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: greyDark,
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    padding: EdgeInsets.only(right: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Iconsax.close_square, size: 28, color: black),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.only(
                    left: appPaddingInApp, right: appPaddingInApp),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: userSearchList.length,
                  // itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        createMessage(userSearchList[index].userId,
                            userSearchList[index].userId);
                        Navigator.pop(context, userSearchList[index].email);
                      },
                      child: Container(
                        width: 263,
                        height: 48,
                        decoration: BoxDecoration(
                          color: white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 16),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: new BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        // '${projects[index]!["background"]}'),
                                        userSearchList[index].avatar),
                                    fit: BoxFit.cover),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      userSearchList[index].name,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: black,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2),
                                    )),
                                Container(
                                    // alignment: Alignment.topLeft,
                                    child: Text(userSearchList[index].job,
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontFamily: 'Poppins',
                                          color: greyDark,
                                          fontWeight: FontWeight.w400,
                                        ))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Spacer(),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //           alignment: Alignment.center,
              //           child: GestureDetector(
              //             // onTap: () => logoutDialog(context),
              //             child: AnimatedContainer(
              //                 alignment: Alignment.center,
              //                 duration: Duration(milliseconds: 300),
              //                 height: 32,
              //                 width: 102,
              //                 decoration: BoxDecoration(
              //                   color: purpleMain,
              //                   borderRadius: BorderRadius.circular(8),
              //                   boxShadow: [
              //                     BoxShadow(
              //                       color: black.withOpacity(0.25),
              //                       spreadRadius: 0,
              //                       blurRadius: 4,
              //                       offset: Offset(0, 4),
              //                     ),
              //                     BoxShadow(
              //                       color: black.withOpacity(0.1),
              //                       spreadRadius: 0,
              //                       blurRadius: 64,
              //                       offset: Offset(15, 15),
              //                     ),
              //                   ],
              //                 ),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Text(
              //                       "Add",
              //                       style: TextStyle(
              //                         color: white,
              //                         fontFamily: 'Poppins',
              //                         fontWeight: FontWeight.w600,
              //                         fontSize: 12,
              //                       ),
              //                     ),
              //                   ],
              //                 )),
              //           )),
              //       SizedBox(width: 8),
              //       Container(
              //           alignment: Alignment.center,
              //           child: GestureDetector(
              //             onTap: () => Navigator.pop(context),
              //             child: AnimatedContainer(
              //                 alignment: Alignment.center,
              //                 duration: Duration(milliseconds: 300),
              //                 height: 32,
              //                 width: 102,
              //                 decoration: BoxDecoration(
              //                   color: white,
              //                   borderRadius: BorderRadius.circular(8),
              //                   boxShadow: [
              //                     BoxShadow(
              //                       color: black.withOpacity(0.10),
              //                       spreadRadius: 0,
              //                       blurRadius: 4,
              //                       offset: Offset(0, 4),
              //                     ),
              //                   ],
              //                 ),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Text(
              //                       "Cancel",
              //                       style: TextStyle(
              //                         color: greyDark,
              //                         fontFamily: 'Poppins',
              //                         fontWeight: FontWeight.w400,
              //                         fontSize: 12,
              //                       ),
              //                     ),
              //                   ],
              //                 )),
              //           )),
              //     ]),
            ],
          ),
        ),
      ],
    ));
  }
}
