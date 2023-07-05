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
import 'package:grow_app/views/project/projectManagement.dart';

//import others
import 'package:meta/meta.dart';

class notificationCenterScreen extends StatefulWidget {
  String uid;

  notificationCenterScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _notificationCenterScreenState createState() =>
      _notificationCenterScreenState(uid);
}

class _notificationCenterScreenState extends State<notificationCenterScreen> {
  // final String? uid = controllers.currentUserId;

  String uid = "";

  _notificationCenterScreenState(uid);

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');
  late String task;

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    print('The current uid is $uid');
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
              SizedBox(height: 64),
              IconButton(
                padding: EdgeInsets.only(left: 28),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, size: 28, color: black),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.only(left: 28),
                child: Text(
                  "Notifications",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 28.0,
                      color: black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.only(
                    left: appPaddingInApp, right: appPaddingInApp),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 10,
                  // itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return Container(
                        width: 319,
                        height: 96,
                        decoration: BoxDecoration(
                            color: purpleLight,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        margin: EdgeInsets.only(top: 8, bottom: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: new BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        // '${projects[index]!["background"]}'),
                                        'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                  width: 215,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              color: black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            children: const <TextSpan>[
                                              TextSpan(
                                                text: 'Bang Bro Best ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    'just added you to task: ',
                                              ),
                                              TextSpan(
                                                text: 'Create New Blog Post',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Today, at 3:15 PM",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12.0,
                                              color: greyDark,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ])),
                            ],
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
