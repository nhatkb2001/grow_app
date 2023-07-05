import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';

//import views
import 'package:grow_app/views/profile/profileCenter.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import others
import 'package:meta/meta.dart';

class settingAppScreen extends StatefulWidget {
  String uid;

  settingAppScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  settingAppScreenState createState() => settingAppScreenState(uid);
}

class settingAppScreenState extends State<settingAppScreen> {
  // final String? uid = controllers.currentUserId;

  String uid = "";

  settingAppScreenState(uid);

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');
  late String task;

  String languageName = 'English';
  String themeMode = 'Dark Mode';

  // List<Widget> _getThemeMode(int count, String name) => List<Widget>.generate(
  //     count,
  //     // (i) => ListTile(title: Text('$name$i')),
  //     (i) => Container(
  //         child: GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 this.themeMode = 'Light Mode';
  //               });
  //             },
  //             child: AnimatedContainer(
  //               margin: EdgeInsets.only(top: 8, left: 14, right: 14),
  //               height: 48,
  //               decoration: BoxDecoration(
  //                 color: purpleLight,
  //                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
  //               ),
  //               duration: Duration(milliseconds: 300),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   SizedBox(width: 16),
  //                   Container(
  //                     width: 245,
  //                     alignment: Alignment.centerLeft,
  //                     child: Text(
  //                       '$name',
  //                       overflow: TextOverflow.ellipsis,
  //                       maxLines: 1,
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         fontFamily: 'Poppins',
  //                         color: black,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                       textAlign: TextAlign.left,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ))));

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
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  IconButton(
                    padding: EdgeInsets.only(left: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios, size: 28, color: black),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.only(bottom: 6, right: 28),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  profileCenterScreen(required, uid: uid),
                            ),
                          );
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: purpleMain,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        )),
                  )
                ]),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 28, right: 28),
                      child: Text(
                        "App Settings",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24.0,
                            color: black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 24),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 28, right: 28),
                          child: Text(
                            "Language",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 20.0,
                                color: black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 28, right: 28),
                                width: 319,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: purpleMain,
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                ),
                                padding: EdgeInsets.only(top: 16, left: 24),
                                child: Text(
                                  "$languageName",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16.0,
                                      color: white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 28),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    iconColor: black,
                                    collapsedIconColor: white,
                                    title: Text(''),
                                    children: [
                                      Container(
                                        width: 348,
                                        height: 70,
                                        padding: EdgeInsets.only(top: 12, left: 28),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              languageName = "English";
                                            });
                                          },
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.only(left: 24),
                                            alignment: Alignment.centerLeft,
                                            duration: Duration(milliseconds: 300),
                                            decoration: BoxDecoration(
                                              color: (languageName == "English") ? purpleDark : purpleLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "English",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16.0,
                                                  color: (languageName == "English") ? white : greyDark,
                                                  fontWeight: FontWeight.w400
                                                ),
                                            )
                                          ),
                                        )
                                      ),
                                      Container(
                                        width: 348,
                                        height: 70,
                                        padding: EdgeInsets.only(top: 12, left: 28),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              languageName = "Vietnamese";
                                            });
                                          },
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.only(left: 24),
                                            alignment: Alignment.centerLeft,
                                            duration: Duration(milliseconds: 300),
                                            decoration: BoxDecoration(
                                              color: (languageName == "Vietnamese") ? purpleDark : purpleLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Vietnamese",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16.0,
                                                  color: (languageName == "Vietnamese") ? white : greyDark,
                                                  fontWeight: FontWeight.w400
                                                ),
                                            )
                                          ),
                                        )
                                      ),
                                      Container(
                                        width: 348,
                                        height: 70,
                                        padding: EdgeInsets.only(top: 12, left: 28),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              languageName = "France";
                                            });
                                          },
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.only(left: 24),
                                            alignment: Alignment.centerLeft,
                                            duration: Duration(milliseconds: 300),
                                            decoration: BoxDecoration(
                                              color: (languageName == "France") ? purpleDark : purpleLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "France",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16.0,
                                                  color: (languageName == "France") ? white : greyDark,
                                                  fontWeight: FontWeight.w400
                                                ),
                                            )
                                          ),
                                        )
                                      ),
                                      Container(
                                        width: 348,
                                        height: 70,
                                        padding: EdgeInsets.only(top: 12, left: 28),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              languageName = "Chinese";
                                            });
                                          },
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.only(left: 24),
                                            alignment: Alignment.centerLeft,
                                            duration: Duration(milliseconds: 300),
                                            decoration: BoxDecoration(
                                              color: (languageName == "Chinese") ? purpleDark : purpleLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Chinese",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16.0,
                                                  color: (languageName == "Chinese") ? white : greyDark,
                                                  fontWeight: FontWeight.w400
                                                ),
                                            )
                                          ),
                                        )
                                      ),
                                      Container(
                                        width: 348,
                                        height: 70,
                                        padding: EdgeInsets.only(top: 12, left: 28),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              languageName = "Indian";
                                            });
                                          },
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.only(left: 24),
                                            alignment: Alignment.centerLeft,
                                            duration: Duration(milliseconds: 300),
                                            decoration: BoxDecoration(
                                              color: (languageName == "Indian") ? purpleDark : purpleLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Indian",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16.0,
                                                  color: (languageName == "Indian") ? white : greyDark,
                                                  fontWeight: FontWeight.w400
                                                ),
                                            )
                                          ),
                                        )
                                      ),
                                    ]
                                  ),
                                ),
                              ),
                            ]
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 28, right: 28),
                          child: Text(
                            "Theme Mode",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 20.0,
                                color: black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 28, right: 28),
                                width: 319,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: purpleMain,
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                ),
                                padding: EdgeInsets.only(top: 16, left: 24),
                                child: Text(
                                  "$themeMode",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16.0,
                                      color: white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 28),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    iconColor: black,
                                    collapsedIconColor: white,
                                    title: Text(''),
                                    children: [
                                      Container(
                                        width: 348,
                                        height: 70,
                                        padding: EdgeInsets.only(top: 12, left: 28),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              themeMode = "Light Mode";
                                            });
                                          },
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.only(left: 24),
                                            alignment: Alignment.centerLeft,
                                            duration: Duration(milliseconds: 300),
                                            decoration: BoxDecoration(
                                              color: (themeMode == "Light Mode") ? purpleDark : purpleLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Light Mode",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16.0,
                                                  color: (themeMode == "Light Mode") ? white : greyDark,
                                                  fontWeight: FontWeight.w400
                                                ),
                                            )
                                          ),
                                        )
                                      ),
                                      Container(
                                        width: 348,
                                        height: 70,
                                        padding: EdgeInsets.only(top: 12, left: 28),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              themeMode = "Dark Mode";
                                            });
                                          },
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.only(left: 24),
                                            alignment: Alignment.centerLeft,
                                            duration: Duration(milliseconds: 300),
                                            decoration: BoxDecoration(
                                              color: (themeMode == "Dark Mode") ? purpleDark : purpleLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Dark Mode",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16.0,
                                                  color: (themeMode == "Dark Mode") ? white : greyDark,
                                                  fontWeight: FontWeight.w400
                                                ),
                                            )
                                          ),
                                        )
                                      ),
                                    ]
                                  ),
                                ),
                              ),
                            ]
                          ),
                        ),
                      ],
                    ),
                  ]
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}
