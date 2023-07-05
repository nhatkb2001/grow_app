import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:grow_app/models/taskModel.dart';
import 'package:grow_app/models/userModel.dart';
import 'package:grow_app/views/profile/notificationCenter.dart';
import 'package:grow_app/views/profile/profileCenter.dart';
import 'package:grow_app/views/task/taskDetail.dart';
import 'package:iconsax/iconsax.dart';

//import widgets
import 'package:grow_app/views/widget/dialogWidget.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';

//import others
import 'package:blur/blur.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:custom_check_box/custom_check_box.dart';

class timelineCenterScreen extends StatefulWidget {
  String uid;

  timelineCenterScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _timelineCenterScreenState createState() => _timelineCenterScreenState(uid);
}

class _timelineCenterScreenState extends State<timelineCenterScreen> {
  String uid = "";

  bool checkBoxValue = false;
  late UserModel user = UserModel(
      avatar: '',
      dob: '',
      email: '',
      name: '',
      messagesList: [],
      job: '',
      tasksList: [],
      phonenumber: '',
      projectsList: [],
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

  List<Task> taskAllList = [];
  List taskAllId = [];
  Future getTaskAllList() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value) {
      taskAllId = value.data()!["tasksList"];
      print(taskAllId);
      FirebaseFirestore.instance
          .collection("tasks")
          .where('deadline',
              isEqualTo: "${DateFormat('yMMMMd').format(DateTime.now())}")
          .snapshots()
          .listen((value) {
        setState(() {
          print("${DateFormat('yMMMMd').format(DateTime.now())}");
          value.docs.forEach((element) {
            // var check = taskAllList
            //     .where((element) => taskAllId.contains(element.taskId));
            // if (check.isEmpty) {
            if (taskAllId.contains(element.data()['taskId'] as String)) {
              taskAllList.add(Task.fromDocument(element.data()));
            }
            // }
          });
          print(taskAllList.length);
        });
      });
      setState(() {});
    });
  }

  ///time
  int now = int.parse("${DateFormat('d').format(DateTime.now())}");

  late DateTime date = DateTime.now();
  late bool checkMonday = false;
  late bool checkTuesDay = false;
  late bool checkFridayDay = false;
  late bool checkWednesDay = false;
  late bool checkThursDay = false;
  late bool checkSaturdayDay = false;
  late bool checkSunDay = false;

  String dateName = '';
  Future getLetterOfDay() async {
    setState(() {
      if ("${DateFormat('EEEE').format(DateTime.now())}" == "Monday") {
        checkMonday = true;
        // dateName = "M";
      }
      if ("${DateFormat('EEEE').format(DateTime.now())}" == "Tuesday") {
        // dateName = "T";
        checkTuesDay = true;
      }
      if ("${DateFormat('EEEE').format(DateTime.now())}" == "Friday") {
        // dateName = "F";
        checkFridayDay = true;
      }
      if ("${DateFormat('EEEE').format(DateTime.now())}" == "Wednesday") {
        // dateName = "W";
        checkWednesDay = true;
      }
      if ("${DateFormat('EEEE').format(DateTime.now())}" == "Thursday") {
        // dateName = "T";
        checkThursDay = true;
      }
      if ("${DateFormat('EEEE').format(DateTime.now())}" == "Saturday") {
        // dateName = "S";
        checkSaturdayDay = true;
      }
      if ("${DateFormat('EEEE').format(DateTime.now())}" == "Sunday") {
        // dateName = "S";
        checkSunDay = true;
      }
    });
  }

  _timelineCenterScreenState(String uid);
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
    getTaskAllList();
    getLetterOfDay();
    print("${DateFormat('EEEE').format(DateTime.now())}");
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      child: Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.all(appPaddingInApp),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 36),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // width: 32,
                            // height: 32,
                            // decoration: new BoxDecoration(
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(8)),
                            //   image: DecorationImage(
                            //       image: NetworkImage(
                            //           // '${projects[index]!["background"]}'),
                            //           'https://scontent.fvca1-4.fna.fbcdn.net/v/t39.30808-1/p480x480/259507941_1162683510806374_690586520604516558_n.jpg?_nc_cat=109&ccb=1-5&_nc_sid=7206a8&_nc_ohc=FtBeikuPI4cAX_rzDg2&_nc_ht=scontent.fvca1-4.fna&oh=8b217f922b39fac368818444711a410a&oe=61B1EDC7'),
                            //       fit: BoxFit.cover),
                            //   shape: BoxShape.rectangle,
                            // ),
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        profileCenterScreen(required, uid: uid),
                                  ),
                                ).then((value) {});
                              },
                              child: AnimatedContainer(
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 300),
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: purpleDark,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(image: NetworkImage(
                                      // '${projects[index]!["background"]}'),
                                      user.avatar), fit: BoxFit.cover),
                                  shape: BoxShape.rectangle,
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
                                      blurRadius: 60,
                                      offset: Offset(10, 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        color: black,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2),
                                  )),
                              SizedBox(width: 4),
                              Container(
                                  // alignment: Alignment.topLeft,
                                  child: Text(user.job,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        color: greyDark,
                                        fontWeight: FontWeight.w400,
                                      ))),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                          // padding: EdgeInsets.only(right: 28),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      notificationCenterScreen(required,
                                          uid: uid),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: purpleMain,
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
                                  child: Icon(Iconsax.notification,
                                      size: 18, color: white)),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Timeline',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Poppins',
                      color: black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // SizedBox(height: 24),
                  Container(
                    margin: EdgeInsets.only(top: 24, bottom: 8),
                    // padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          buildDateColumn('S', now - 3, checkSunDay),
                          buildDateColumn('M', now - 3, checkMonday),
                          buildDateColumn('T', now - 2, checkTuesDay),
                          buildDateColumn('W', now - 1, checkWednesDay),
                          buildDateColumn('T', now, checkThursDay),
                          buildDateColumn('F', 1, checkFridayDay),
                          buildDateColumn('S', 2, checkSunDay),
                        ]),
                  ),
                  Column(
                    children: [
                      buildCardTask('Today Task'),
                    ],
                  )
                ])),
      ),
    );
  }

  Container buildCardTask(String hour) {
    return Container(
      margin: EdgeInsets.only(top: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                  width: 15,
                  height: 10,
                  decoration: BoxDecoration(
                      color: purpleDark,
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(4)))),
              SizedBox(width: 16),
              Text(
                hour,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: black,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          (taskAllList.length != 0)
              ? Container(
                  // padding: EdgeInsets.only(
                  //     left: appPaddingInApp, right: appPaddingInApp),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: taskAllList.length,
                    // itemCount: projects.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => taskDetailScreen(
                                required,
                                uid: uid,
                                taskId: taskAllList[index].taskId,
                                projectId: taskAllList[index].projectId,
                              ),
                            ),
                          ).then((value) {
                            // getProjectsDataList();
                          });
                        },
                        child: AnimatedContainer(
                          width: 319,
                          height: 80,
                          decoration: BoxDecoration(
                              color: purpleLight,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          padding: EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: appPaddingInApp,
                              right: appPaddingInApp),
                          duration: Duration(milliseconds: 300),
                          child: Container(
                            // padding: EdgeInsets.only(
                            //     left: 24, top: 12, bottom: 12, right: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                      Container(
                                          width: 213,
                                          child: Text(
                                            taskAllList[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 16.0,
                                                color: black,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      SizedBox(height: 8),
                                      Container(
                                        width: 168,
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.zero,
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                      Iconsax.calendar_1,
                                                      size: 16,
                                                      color: greyDark)),
                                              SizedBox(width: 8),
                                              Text(
                                                taskAllList[index].deadline,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 12.0,
                                                    color: greyDark,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ]),
                                      )
                                    ])),
                                Spacer(),
                                // Container(
                                //     child: Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.end,
                                //         children: [
                                // SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  width: 10,
                                  height: 10,
                                  decoration: new BoxDecoration(
                                    color: (taskAllList[index].status == "todo")
                                        ? todoColor
                                        : ((taskAllList[index].status == "done")
                                            ? doneColor
                                            : pendingColor),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                // ])),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(top: 64),
                  alignment: Alignment.center,
                  child: Text(
                    "You don't have tasks today!",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16.0,
                      color: black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Container buildTask(String taskName) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        height: 48,
        decoration: BoxDecoration(
          color: purpleLight,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 16),
            Container(
              width: 245,
              alignment: Alignment.centerLeft,
              child: Text(
                taskName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.only(right: 4.0),
              alignment: Alignment.topRight,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: new CustomCheckBox(
                  value: checkBoxValue,
                  shouldShowBorder: true,
                  borderColor: purpleHide,
                  checkedFillColor: purpleHide,
                  checkedIconColor: white,
                  borderRadius: 4,
                  borderWidth: 1.5,
                  checkBoxSize: 16,
                  // onChanged: _activeCheckAccept,
                  onChanged: (bool newValue) {
                    setState(() {
                      checkBoxValue = newValue;
                    });
                  }),
            ),
            // Container(
            //     width: 18,
            //     height: 18,
            //     decoration: BoxDecoration(
            //       color: white,
            //       // borderRadius: BorderRadius.all(Radius.circular(4))
            //       border: Border(
            //         top: BorderSide(
            //             width: 2.0, color: todoColor, style: BorderStyle.solid),
            //         left: BorderSide(
            //             width: 2.0, color: todoColor, style: BorderStyle.solid),
            //         right: BorderSide(
            //             width: 2.0, color: todoColor, style: BorderStyle.solid),
            //         bottom: BorderSide(
            //             width: 2.0, color: todoColor, style: BorderStyle.solid),
            //       ),
            //     )
            // ),
          ],
        ));
  }

  Container buildDateColumn(String weekDay, int date, bool isActive) {
    return Container(
      height: 52,
      width: 36,
      decoration: isActive
          ? BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: purpleDark,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)), color: white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(weekDay,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: isActive ? white : greyDark,
                fontWeight: FontWeight.w400,
              )),
          SizedBox(height: 2),
          Text(date.toString(),
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: isActive ? white : black,
                fontWeight: FontWeight.w600,
              ))
        ],
      ),
    );
  }
}
