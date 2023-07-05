import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grow_app/models/userModel.dart';

//import widgets
import 'package:grow_app/views/widget/dialogWidget.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

//import views
import 'package:grow_app/views/profile/termCondition.dart';
import 'package:grow_app/views/profile/helpCenter.dart';
import 'package:grow_app/views/profile/loginDetail.dart';
import 'package:grow_app/views/profile/settingApp.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';

class profileCenterScreen extends StatefulWidget {
  String uid;

  profileCenterScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _profileCenterScreenState createState() => _profileCenterScreenState(uid);
}

class _profileCenterScreenState extends State<profileCenterScreen> {
  // final String? uid = controllers.currentUserId;

  String uid = "";
  late UserModel user = UserModel(
      avatar: '',
      dob: '',
      email: '',
      name: '',
      messagesList: [],
      job: '',
      phonenumber: '',
      projectsList: [],
      tasksList: [],
      userId: '');
  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .listen((value) {
      setState(() {
        user = UserModel.fromDocument(value.docs.first.data());
      });
    });
  }

  late PickedFile image = PickedFile('');
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      image = pickedFile!;
    });
    // final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    // final pickedImageFile = File(pickedImage!.path);
    // setState(() {
    //   image = pickedImageFile;
    // });
  }

  _profileCenterScreenState(uid);

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');
  late String task;

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    print('The current uid is $uid');
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 64),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: EdgeInsets.only(left: 28),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios,
                              size: 28, color: black),
                        ),
                      ],
                    ),
                    SizedBox(height: 28),
                    Container(
                      width: 112,
                      height: 108,
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Container(
                            // padding: EdgeInsets.only(top: 36, left: 22),
                            alignment: Alignment.topLeft,
                            width: 100,
                            height: 100,
                            decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              image: (image == null)
                                  ? DecorationImage(
                                      image: FileImage(File(image.path)),
                                      fit: BoxFit.cover)
                                  : DecorationImage(image: NetworkImage(
                                      // '${projects[index]!["background"]}'),
                                      user.avatar), fit: BoxFit.cover),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 72, left: 72),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  getImage(ImageSource.camera);
                                },
                                child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 300),
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: purpleDark,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          color: black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 64,
                                          offset: Offset(8, 8)),
                                      BoxShadow(
                                        color: black.withOpacity(0.2),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      child: Icon(Iconsax.edit,
                                          size: 16, color: white)),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: black,
                              fontWeight: FontWeight.w700,
                              fontSize: 24),
                        ),
                        SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: greyDark,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        )
                      ],
                    ),
                    SizedBox(height: 48),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.15, color: greyDark),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          loginDetailScreen(required, uid: uid),
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 300),
                                  height: 64,
                                  width: 319,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 24),
                                      Container(
                                          width: 32,
                                          height: 32,
                                          // alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: white,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.zero,
                                            child: Icon(Iconsax.profile_2user,
                                                size: 20, color: purpleMain),
                                          )),
                                      SizedBox(width: 16),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text(
                                            'Login details',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                color: purpleMain,
                                                fontWeight: FontWeight.w600),
                                          )),
                                          SizedBox(width: 4),
                                          Container(
                                              // alignment: Alignment.topLeft,
                                              child: Text(
                                                  'User name, Password,...',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: 'Poppins',
                                                    color: greyDark,
                                                    fontWeight: FontWeight.w400,
                                                  ))),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.center,
                                          child: Icon(Iconsax.arrow_right,
                                              size: 24, color: purpleMain)),
                                      SizedBox(width: 20)
                                    ],
                                  ),
                                ))),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.15, color: greyDark),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => helpCenterScreen(),
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 300),
                                  height: 64,
                                  width: 319,
                                  decoration: BoxDecoration(
                                    color: white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 24),
                                      Container(
                                          width: 32,
                                          height: 32,
                                          // alignment: Alignment.center,
                                          decoration: new BoxDecoration(
                                            border: Border.all(
                                                width: 0.2, color: greyDark),
                                            color: white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.zero,
                                            child: Icon(Iconsax.headphone,
                                                size: 20, color: purpleMain),
                                          )),
                                      SizedBox(width: 16),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text(
                                            'Help',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                color: purpleMain,
                                                fontWeight: FontWeight.w600),
                                          )),
                                          SizedBox(width: 4),
                                          Container(
                                              // alignment: Alignment.topLeft,
                                              child: Text('FAQs, Helpdesk',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: 'Poppins',
                                                    color: greyDark,
                                                    fontWeight: FontWeight.w400,
                                                  ))),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.center,
                                          child: Icon(Iconsax.arrow_right,
                                              size: 24, color: purpleMain)),
                                      SizedBox(width: 20)
                                    ],
                                  ),
                                ))),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.15, color: greyDark),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => conditionScreen(),
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 300),
                                  height: 64,
                                  width: 319,
                                  decoration: BoxDecoration(
                                    color: white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 24),
                                      Container(
                                          width: 32,
                                          height: 32,
                                          // alignment: Alignment.center,
                                          decoration: new BoxDecoration(
                                            border: Border.all(
                                                width: 0.2, color: greyDark),
                                            color: white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.zero,
                                            child: Icon(Iconsax.document_text,
                                                size: 20, color: purpleMain),
                                          )),
                                      SizedBox(width: 16),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text(
                                            'Legal information',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                color: purpleMain,
                                                fontWeight: FontWeight.w600),
                                          )),
                                          SizedBox(width: 4),
                                          Container(
                                              // alignment: Alignment.topLeft,
                                              child: Text(
                                                  'Terms & Conditions, Privacy Policy',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: 'Poppins',
                                                    color: greyDark,
                                                    fontWeight: FontWeight.w400,
                                                  ))),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.center,
                                          child: Icon(Iconsax.arrow_right,
                                              size: 24, color: purpleMain)),
                                      SizedBox(width: 20)
                                    ],
                                  ),
                                ))),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.15, color: greyDark),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16)),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          settingAppScreen(required, uid: uid),
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 300),
                                  height: 64,
                                  width: 319,
                                  decoration: BoxDecoration(
                                    color: white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 24),
                                      Container(
                                          width: 32,
                                          height: 32,
                                          // alignment: Alignment.center,
                                          decoration: new BoxDecoration(
                                            border: Border.all(
                                                width: 0.2, color: greyDark),
                                            color: white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.zero,
                                            child: Icon(Iconsax.setting_2,
                                                size: 20, color: purpleMain),
                                          )),
                                      SizedBox(width: 16),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text(
                                            'Setting',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                color: purpleMain,
                                                fontWeight: FontWeight.w600),
                                          )),
                                          SizedBox(width: 4),
                                          Container(
                                              // alignment: Alignment.topLeft,
                                              child: Text(
                                                  'Language, Theme Mode,...',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: 'Poppins',
                                                    color: greyDark,
                                                    fontWeight: FontWeight.w400,
                                                  ))),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.center,
                                          child: Icon(Iconsax.arrow_right,
                                              size: 24, color: purpleMain)),
                                      SizedBox(width: 20)
                                    ],
                                  ),
                                )))
                      ],
                    ),
                    SizedBox(height: 56),
                    Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => logoutDialog(context),
                          child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              height: 48,
                              width: 200,
                              decoration: BoxDecoration(
                                // color: getColor(purpleDark, purpleDark.withOpacity(0.3)),
                                color: purpleDark,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withOpacity(0.25),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: black.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 64,
                                    offset: Offset(15, 15),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      child: Icon(Iconsax.logout,
                                          size: 24, color: white)),
                                  SizedBox(width: 12),
                                  Text(
                                    "Log out",
                                    style: TextStyle(
                                      color: white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(width: 12)
                                ],
                              )),
                        ))
                  ])),
        ],
      ),
    );
  }
}
