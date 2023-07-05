import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';
import 'package:grow_app/controllers/projectController.dart';
import 'package:grow_app/models/projectModel.dart';
import 'package:grow_app/models/taskModel.dart';
import 'package:grow_app/models/userModel.dart';
import 'package:grow_app/views/dashboard/dashboardCenter.dart';
import 'package:grow_app/views/project/projectDetail.dart';

//import widgets
import 'package:grow_app/views/widget/dialogWidget.dart';

//import views
import 'package:grow_app/views/project/projectManagement.dart';
import 'package:grow_app/views/project/circleProgressProject.dart';
import 'package:grow_app/views/project/projectEditing.dart';
import 'package:grow_app/views/task/taskCreating.dart';
import 'package:grow_app/views/task/taskEditing.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:custom_check_box/custom_check_box.dart';

class taskDetailScreen extends StatefulWidget {
  String uid;
  String taskId;
  String projectId;

  taskDetailScreen(Required required,
      {Key? key,
      required this.uid,
      required this.taskId,
      required this.projectId})
      : super(key: key);

  @override
  _taskDetailScreenState createState() =>
      _taskDetailScreenState(uid, taskId, projectId);
}

class _taskDetailScreenState extends State<taskDetailScreen>
    with SingleTickerProviderStateMixin {
  // final String? uid = controllers.currentUserId;

  String uid = "";
  String taskId = "";
  String projectId = "";

  String idOwner = "";
  List taskIdList = [];
  List assigned = [];
  late Task task = Task(
      deadline: '',
      description: '',
      name: '',
      owner: "",
      progress: '',
      projectId: '',
      status: '',
      taskId: '',
      assigned: []);
  late UserModel user = UserModel(
      avatar: '',
      dob: '',
      tasksList: [],
      email: '',
      messagesList: [],
      name: '',
      job: '',
      phonenumber: '',
      projectsList: [],
      userId: '');
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

  List<UserModel> userList = [];

  List taskIds = [];
  List<Task> taskDoneList = [];

  bool checkBoxValue = false;
  double progress = 0;
  double progressProject = 0;

  _taskDetailScreenState(uid, this.taskId, this.projectId);

  TabController? _tabController;
  int _selectedIndex = 0;
  double _currentPosition = 1.0;

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');
  List assignee = [];

  Future getAssigned() async {
    FirebaseFirestore.instance
        .collection("tasks")
        .doc(taskId)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance.collection("users").get().then((value2) {
        setState(() {
          userList.clear();
          assignee = value1.data()!["assigned"];
          value2.docs.forEach((element) {
            if (assignee.contains(element.data()['userId'] as String)) {
              userList.add(UserModel.fromDocument(element.data()));
            }
            // }
          });
        });
      });
    });
  }

  Future getIdOwner() async {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .snapshots()
        .listen((value) {
      setState(() {
        idOwner = value.data()!["owner"];
      });
      print(idOwner);
    });
  }

  Future getTaskDetail() async {
    FirebaseFirestore.instance
        .collection("tasks")
        .where("taskId", isEqualTo: taskId)
        .snapshots()
        .listen((value) {
      setState(() {
        task = Task.fromDocument(value.docs.first.data());
        if (task.progress == '0') {
          checkBoxValue = false;
        } else {
          if ((task.progress + ".0") == (100.0).toString()) {
            checkBoxValue = true;
          } else {
            checkBoxValue = false;
          }
        }
      });
      print(task.name);
    });
  }

  Future updateProgressProject() async {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .snapshots()
        .listen((value1) {
      print(taskIds);
      FirebaseFirestore.instance
          .collection("tasks")
          .where("status", isEqualTo: 'done')
          .snapshots()
          .listen((value2) {
        setState(() {
          taskDoneList.clear();
          taskIds = value1.data()!["tasksListId"];
          value2.docs.forEach((element) {
            if (taskIds.contains(element.data()['taskId'] as String)) {
              taskDoneList.add(Task.fromDocument(element.data()));
            }
          });
          print(taskDoneList.length);
        });
      });
    });
  }

  Future getProjectsDetail() async {
    FirebaseFirestore.instance
        .collection("projects")
        .where("projectId", isEqualTo: projectId)
        .snapshots()
        .listen((value) {
      project = Project.fromDocument(value.docs.first.data());
      print("project.quantityTask");
      print(project.quantityTask);
    });
  }

  Future checkAssignment(double progress) async {
    FirebaseFirestore.instance.collection("projects").doc(projectId).update({
      'progress': (double.parse(project.progress + '.0') +
              (progress / double.parse(project.quantityTask + '.0')))
          .toStringAsFixed(0)
          .toString(),
      'status': ((double.parse(project.progress + '.0') +
                      (progress / double.parse(project.quantityTask + '.0')))
                  .toStringAsFixed(0)
                  .toString() ==
              "100")
          ? "done"
          : ((double.parse(project.progress + '.0') +
                          (progress /
                              double.parse(project.quantityTask + '.0')))
                      .toStringAsFixed(0)
                      .toString() !=
                  "0")
              ? "todo"
              : "pending"
    }).whenComplete(() =>
        FirebaseFirestore.instance.collection("tasks").doc(taskId).update({
          'progress': (double.parse(task.progress + '.0') + progress)
              .toStringAsFixed(0)
              .toString(),
          'status': ((double.parse(task.progress + '.0') + progress)
                      .toStringAsFixed(0)
                      .toString() ==
                  "100")
              ? "done"
              : ((double.parse(task.progress + '.0') + progress)
                          .toStringAsFixed(0)
                          .toString() !=
                      "0")
                  ? "todo"
                  : "pending"
        }));
  }

  String newTaskSubId = '';

  Future checkAssignmentStatus(String taskId, String newTaskSubId) async {
    FirebaseFirestore.instance.collection("subTasks").add({
      'taskId': taskId,
      'userId': uid,
      'checked': checkBoxValue,
    }).then((value) =>
        FirebaseFirestore.instance.collection("subTasks").doc(value.id).update({
          'taskSubId': value.id,
        }));
  }

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    print('The current uid is $uid');
    _tabController = TabController(length: 4, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _tabController != _tabController;
      });
      _selectedIndex = _tabController!.index;
      print(_selectedIndex);
    });
    getTaskDetail();
    getIdOwner();
    getAssigned();
    getProjectsDetail();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 64),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                IconButton(
                  padding: EdgeInsets.only(left: 28),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         dashboardCenterScreen(required, uid: uid),
                    //   ),
                    // );
                    // Navigator.pop(context).then((value) {
                    //   setState(() {});
                    // });
                    Navigator.pop(context);
                    // setState(() {});
                  },
                  icon: Icon(Icons.arrow_back_ios, size: 28, color: black),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(bottom: 6, right: 28),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => taskEditingScreen(required,
                                uid: uid, taskId: taskId, projectId: projectId),
                          ),
                        );
                      },
                      child: Text(
                        (uid == idOwner) ? "Edit" : "",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: greyDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )),
                )
              ]),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 28, right: 28),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          task.name,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 24.0,
                              color: black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        child: Text(
                          (task.status == "done")
                              ? "Done"
                              : ((task.status == "todo") ? "To Do" : "Pending"),
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16.0,
                              color: (task.status == "done")
                                  ? doneColor
                                  : ((task.status == "todo")
                                      ? todoColor
                                      : pendingColor),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 8),
                      Stack(
                        children: [
                          Container(
                            width: 271,
                            height: 9,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: (271 *
                                0.01 *
                                double.parse(task.progress + ".0")),
                            height: 9,
                            decoration: BoxDecoration(
                                color: (task.status == "done")
                                    ? doneColor
                                    : ((task.status == "todo")
                                        ? todoColor
                                        : pendingColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withOpacity(0.25),
                                    spreadRadius: 0,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: 319,
                        height: 48,
                        padding: EdgeInsets.only(
                            top: 8, left: 16, bottom: 8, right: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: purpleLight),
                        alignment: Alignment.center,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(Iconsax.notification_1,
                                    size: 20, color: purpleMain),
                              ),
                              SizedBox(width: 16),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: greyDark,
                                      fontWeight: FontWeight.w500,
                                      // height: 1.6,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Deadline: ',
                                      ),
                                      TextSpan(
                                        text: task.deadline,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Overview",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20.0,
                                  color: black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Text(
                              task.description,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12.0,
                                color: greyDark,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Column(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Team Members",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 20.0,
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                              // margin: EdgeInsets.only(left: 32),
                                              alignment: Alignment.center,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            projectEditingScreen(
                                                                required,
                                                                uid: uid,
                                                                projectId:
                                                                    projectId)),
                                                  );
                                                },
                                                child: AnimatedContainer(
                                                  alignment: Alignment.center,
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  child: DottedBorder(
                                                    child: Container(
                                                      width: 36,
                                                      height: 36,
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(Iconsax.add,
                                                            size: 24,
                                                            color: greyDark),
                                                      ),
                                                    ),
                                                    borderType: BorderType.Oval,
                                                    color: greyDark,
                                                    dashPattern: [
                                                      10,
                                                      5,
                                                      10,
                                                      5,
                                                      10,
                                                      5
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          Container(
                                            // width: 367,
                                            height: 48,
                                            child: ListView.builder(
                                                padding: EdgeInsets.only(
                                                    left: 36 + 8),
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    userList.length.clamp(0, 3),
                                                itemBuilder: (context, index) {
                                                  return Stack(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 4, right: 4),
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            new BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  userList[
                                                                          index]
                                                                      .avatar),
                                                              fit:
                                                                  BoxFit.cover),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      ),
                      SizedBox(height: 32),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Task Status",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 20.0,
                                    color: black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                                width: 319,
                                padding: EdgeInsets.only(
                                    top: 24, left: 20, right: 20, bottom: 24),
                                decoration: BoxDecoration(
                                  color: purpleLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: userList.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 280,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius: (index == 0)
                                                  ? BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      topRight:
                                                          Radius.circular(8))
                                                  : BorderRadius.all(
                                                      Radius.circular(0)),
                                              border: (index == 2)
                                                  ? Border()
                                                  : Border(
                                                      top: BorderSide(
                                                          width: 0.1,
                                                          color: greyDark),
                                                      left: BorderSide(
                                                          width: 0.1,
                                                          color: greyDark),
                                                      right: BorderSide(
                                                          width: 0.1,
                                                          color: greyDark),
                                                      bottom: BorderSide(
                                                          width: 0.1,
                                                          color: greyDark),
                                                    ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(width: 16),
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            userList[index]
                                                                .avatar
                                                            // '${projects[index]!["background"]}'),
                                                            ),
                                                        fit: BoxFit.cover),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          userList[index].name,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1.2),
                                                        )),
                                                    Container(
                                                        // alignment: Alignment.topLeft,
                                                        child: Text(
                                                            userList[index].job,
                                                            style: TextStyle(
                                                              fontSize: 8,
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: greyDark,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ))),
                                                  ],
                                                ),
                                                Spacer(),
                                                (userList[index].userId == uid)
                                                    ? Container(
                                                        // padding: const EdgeInsets.only(right: 23.0),
                                                        alignment:
                                                            Alignment.topRight,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child:
                                                            new CustomCheckBox(
                                                                value:
                                                                    checkBoxValue,
                                                                shouldShowBorder:
                                                                    true,
                                                                borderColor:
                                                                    purpleHide,
                                                                checkedFillColor:
                                                                    purpleHide,
                                                                checkedIconColor:
                                                                    white,
                                                                borderRadius: 4,
                                                                borderWidth:
                                                                    1.5,
                                                                checkBoxSize:
                                                                    16,
                                                                // onChanged: _activeCheckAccept,
                                                                onChanged: (bool
                                                                    newValue) {
                                                                  setState(() {
                                                                    checkBoxValue =
                                                                        newValue;
                                                                    (newValue ==
                                                                            true)
                                                                        ? progress =
                                                                            ((1 / userList.length) *
                                                                                100)
                                                                        : progress =
                                                                            -((1 / userList.length) *
                                                                                100);
                                                                    checkAssignment(
                                                                        progress);
                                                                  });
                                                                }),
                                                      )
                                                    : Container(),
                                                SizedBox(width: 16)
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 23),
                                    ]))
                          ]),
                    ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
