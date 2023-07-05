import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';
import 'package:grow_app/models/projectModel.dart';
import 'package:grow_app/models/taskModel.dart';
import 'package:grow_app/models/userModel.dart';

//import widgets
import 'package:grow_app/views/widget/dialogWidget.dart';

//import views
import 'package:grow_app/views/project/projectManagement.dart';
import 'package:grow_app/views/project/circleProgressProject.dart';
import 'package:grow_app/views/project/projectEditing.dart';
import 'package:grow_app/views/task/taskCreating.dart';
import 'package:grow_app/views/task/taskDetail.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dotted_border/dotted_border.dart';

class projectDetailScreen extends StatefulWidget {
  String uid;
  String projectId;
  late Project project;

  projectDetailScreen(Required required,
      {Key? key, required this.uid, required this.projectId})
      : super(key: key);

  @override
  _projectDetailScreenState createState() =>
      _projectDetailScreenState(uid, projectId);
}

class _projectDetailScreenState extends State<projectDetailScreen>
    with SingleTickerProviderStateMixin {
  // final String? uid = controllers.currentUserId;

  String uid = "";
  String projectId = "";
  String idOwner = "";
  List projectIds = [];
  List userProjectListId = [];
  List taskIds = [];

  List assigned = [];
  List assignedTask = [];
  List<UserModel> userListTask = [];

  List<Task> taskTodoList = [];

  List<Task> taskDoneList = [];

  List<Task> taskPendingList = [];

  List<Task> taskAllList = [];
  List taskAllId = [];

  List<Project> projectAllList = [];

  List<UserModel> userList = [];

  int selected = 0;
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
  late Task task = Task(
      deadline: '',
      description: '',
      name: '',
      progress: '',
      projectId: '',
      status: '',
      owner: "",
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

  _projectDetailScreenState(uid, this.projectId);

  TabController? _tabController;
  int _selectedIndex = 0;
  double _currentPosition = 1.0;

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');

  Future getProjectsDetail() async {
    FirebaseFirestore.instance
        .collection("projects")
        .where("projectId", isEqualTo: projectId)
        .snapshots()
        .listen((value) {
      setState(() {
        project = Project.fromDocument(value.docs.first.data());
      });
      print(project.progress);
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

  Future getAssigned() async {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance.collection("users").get().then((value2) {
        setState(() {
          userList.clear();
          assigned = value1.data()!["assigned"];
          value2.docs.forEach((element) {
            if (assigned.contains(element.data()['userId'] as String)) {
              userList.add(UserModel.fromDocument(element.data()));
            }
          });
          print("userList.length");
          print(userList.length);
        });
      });
    });
  }

  List taskList = [];
  Future getAssignedTask() async {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .snapshots()
        .listen((value1) {
      setState(() {
        taskList = value1.data()!["tasksListId"];
        taskList.forEach((element) {
          FirebaseFirestore.instance
              .collection("tasks")
              .doc(element)
              .snapshots()
              .listen((value2) {
            assignedTask = value2.data()!["assigned"];
            // setState(() {

            FirebaseFirestore.instance.collection("users").get().then((value3) {
              setState(() {
                userListTask.clear();
                value3.docs.forEach((element) {
                  if (assignedTask
                      .contains(element.data()['userId'] as String)) {
                    userListTask.add(UserModel.fromDocument(element.data()));
                  }
                });
              });
            });
            // });
          });
        });
      });
      print("task avatar ne");
      print(userListTask.length);
    });
  }

  Future getTaskTodoList() async {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance
          .collection("tasks")
          .where("status", isEqualTo: 'todo')
          .snapshots()
          .listen((value2) {
        setState(() {
          taskTodoList.clear();
          taskIds = value1.data()!["tasksListId"];
          print('getTaskTodoList');
          value2.docs.forEach((element) {
            if (taskIds.contains(element.data()['taskId'] as String)) {
              taskTodoList.add(Task.fromDocument(element.data()));
            }
          });
          print(taskTodoList.length);
        });
      });
    });
  }

  Future getTaskPendingList() async {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .snapshots()
        .listen((value1) {
      print(taskIds);
      FirebaseFirestore.instance
          .collection("tasks")
          .where("status", isEqualTo: 'pending')
          .snapshots()
          .listen((value2) {
        setState(() {
          taskPendingList.clear();
          taskIds = value1.data()!["tasksListId"];
          value2.docs.forEach((element) {
            if (taskIds.contains(element.data()['taskId'] as String)) {
              taskPendingList.add(Task.fromDocument(element.data()));
            }
          });
        });
      });
    });
  }

  Future getTaskDoneList() async {
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
          print('getTaskDoneList');
          value2.docs.forEach((element) {
            if (taskIds.contains(element.data()['taskId'] as String)) {
              taskDoneList.add(Task.fromDocument(element.data()));
              // }
            }
          });
        });
      });
    });
  }

  Future getTaskAllList() async {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .snapshots()
        .listen((value1) {
      // setState(() {

      //   // setState(() {});
      // });
      print("xoa thon tin ne");
      // taskAllList.clear();
      print("So luong task all ban dau ne");
      print(taskAllList.length);
      print(taskIds);
      FirebaseFirestore.instance
          .collection("tasks")
          .snapshots()
          .listen((value2) {
        setState(() {
          taskAllList.clear();
          taskAllId.clear();
          taskAllId = value1.data()!["tasksListId"];
          value2.docs.forEach((element) {
            // taskAllList.clear();
            //     .where((element) => taskAllId.contains(element.taskId));
            // if (check.isEmpty) {
            if (taskAllId.contains(element.data()['taskId'] as String)) {
              taskAllList.add(Task.fromDocument(element.data()));
            }
            // if (mounted) setState(() {});
            // }
            print(taskAllList.length);
          });
        });
      });
    });
  }

  // Future getUserAssigned() async {
  //   FirebaseFirestore.instance.collection("users").snapshots().listen((value) {
  //     setState(() {
  //       userProjectListId = value.data()!["projectsList"];
  //     });
  //   });
  // }

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
    });
    getTaskAllList();
    getProjectsDetail();
    getTaskTodoList();
    getTaskDoneList();
    getTaskPendingList();
    getAssigned();
    getIdOwner();
    // getAssignedTask();
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
                    //         projectManagementScreen(required, uid: uid),
                    //   ),
                    // );
                    Navigator.pop(context);
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
                            builder: (context) => projectEditingScreen(required,
                                uid: uid, projectId: projectId),
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
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                project.name,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 24.0,
                                    color: black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              child: Text(
                                project.description,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12.0,
                                  color: greyDark,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ]),
                      SizedBox(height: 24),
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
                                        text: project.deadline,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                child: CustomPaint(
                                  // foregroundPainter: circleProgressProject(100),
                                  foregroundPainter: circleProgressProject(
                                      double.parse(project.progress + '.0')),
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        project.progress + "%",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 8.0,
                                            color: purpleMain,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]),
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
                                      (uid == idOwner)
                                          ? Column(
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
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
                                                        alignment:
                                                            Alignment.center,
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        child: DottedBorder(
                                                          child: Container(
                                                            width: 34,
                                                            height: 34,
                                                            decoration:
                                                                new BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Icon(
                                                                  Iconsax.add,
                                                                  size: 24,
                                                                  color:
                                                                      greyDark),
                                                            ),
                                                          ),
                                                          borderType:
                                                              BorderType.Oval,
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
                                                SizedBox(height: 4),
                                              ],
                                            )
                                          : Container(),
                                      Container(
                                        // width: 367,
                                        height: 48,
                                        child: ListView.builder(
                                            padding: EdgeInsets.only(left: 0),
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                userList.length.clamp(0, 3),
                                            itemBuilder: (context, index) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 0, right: 8),
                                                    width: 40,
                                                    height: 40,
                                                    decoration:
                                                        new BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              userList[index]
                                                                  .avatar),
                                                          fit: BoxFit.cover),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ]),
              ),
              SizedBox(height: 32),
              Container(
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: EdgeInsets.only(left: 28),
                  labelPadding: EdgeInsets.only(right: 16),
                  isScrollable: true,
                  onTap: (value) {
                    setState(() {
                      _tabController != _tabController;
                    });
                  },
                  tabs: [
                    Container(
                      width: 80,
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: (_selectedIndex == 0) ? purpleMain : white),
                      alignment: Alignment.center,
                      child: Tab(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: (_selectedIndex == 0) ? white : greyDark,
                              fontWeight: FontWeight.w500,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'All',
                              ),
                              TextSpan(
                                text: " " + taskAllList.length.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: (_selectedIndex == 1) ? purpleMain : white),
                      alignment: Alignment.center,
                      child: Tab(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: (_selectedIndex == 1) ? white : greyDark,
                              fontWeight: FontWeight.w500,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Todo',
                              ),
                              TextSpan(
                                text: ' ' + taskTodoList.length.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: (_selectedIndex == 2) ? purpleMain : white),
                      alignment: Alignment.center,
                      child: Tab(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: (_selectedIndex == 2) ? white : greyDark,
                              fontWeight: FontWeight.w500,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Pending',
                              ),
                              TextSpan(
                                text: ' ' + taskPendingList.length.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: (_selectedIndex == 3) ? purpleMain : white),
                      alignment: Alignment.center,
                      child: Tab(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: (_selectedIndex == 3) ? white : greyDark,
                              fontWeight: FontWeight.w500,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Done',
                              ),
                              TextSpan(
                                text: ' ' + taskDoneList.length.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16),
                width: double.maxFinite,
                height: 340,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    //All Tabbar
                    Container(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                                    projectId: projectId,
                                  ),
                                ),
                              ).then((value) {
                                //   setState(() {
                                //    taskAllList.clear();
                                //     getTaskAllList();
                                //    });
                                getTaskAllList();
                              });
                            },
                            child: AnimatedContainer(
                              width: 319,
                              height: 80,
                              decoration: BoxDecoration(
                                  color: purpleLight,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              margin: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8.0,
                                  left: appPaddingInApp,
                                  right: appPaddingInApp),
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 24, top: 12, bottom: 12, right: 24),
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
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                          Iconsax.calendar_1,
                                                          size: 16,
                                                          color: greyDark)),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    taskAllList[index].deadline,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                    Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                          SizedBox(height: 8),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: new BoxDecoration(
                                              color:
                                                  (taskAllList[index].status ==
                                                          "done")
                                                      ? doneColor
                                                      : ((taskAllList[index]
                                                                  .status ==
                                                              "todo")
                                                          ? todoColor
                                                          : pendingColor),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 20,
                                            child: ListView.builder(
                                                padding:
                                                    EdgeInsets.only(right: 0),
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: userListTask.length
                                                    .clamp(0, 3),
                                                itemBuilder: (context, index) {
                                                  return Stack(children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 0, right: 0),
                                                      width: 20,
                                                      height: 20,
                                                      decoration:
                                                          new BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                userListTask[
                                                                        index]
                                                                    .avatar),
                                                            fit: BoxFit.cover),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                  ]);
                                                }),
                                          ),
                                        ])),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    //Todo Tabbar
                    Container(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: taskTodoList.length,
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
                                    taskId: taskTodoList[index].taskId,
                                    projectId: projectId,
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
                              margin: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8.0,
                                  left: appPaddingInApp,
                                  right: appPaddingInApp),
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 24, top: 12, bottom: 12, right: 24),
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
                                                taskTodoList[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16.0,
                                                    color: black,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                          Iconsax.calendar_1,
                                                          size: 16,
                                                          color: greyDark)),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    taskTodoList[index]
                                                        .deadline,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                    Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                          SizedBox(height: 8),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: new BoxDecoration(
                                              color:
                                                  (taskTodoList[index].status ==
                                                          "todo")
                                                      ? todoColor
                                                      : ((taskTodoList[index]
                                                                  .status ==
                                                              "done")
                                                          ? doneColor
                                                          : pendingColor),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 20,
                                            child: ListView.builder(
                                                // padding:
                                                //     EdgeInsets.only(right: 8),
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: userListTask.length
                                                    .clamp(0, 3),
                                                itemBuilder: (context, index) {
                                                  return Stack(children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 4),
                                                      width: 20,
                                                      height: 20,
                                                      decoration:
                                                          new BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                userListTask[
                                                                        index]
                                                                    .avatar),
                                                            fit: BoxFit.cover),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                  ]);
                                                }),
                                          ),
                                        ])),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    //Pending Tabbar
                    Container(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: taskPendingList.length,
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
                                    taskId: taskPendingList[index].taskId,
                                    projectId: projectId,
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
                              margin: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8.0,
                                  left: appPaddingInApp,
                                  right: appPaddingInApp),
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 24, top: 12, bottom: 12, right: 24),
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
                                                taskPendingList[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16.0,
                                                    color: black,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                          Iconsax.calendar_1,
                                                          size: 16,
                                                          color: greyDark)),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    taskPendingList[index]
                                                        .deadline,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                    Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                          SizedBox(height: 8),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: new BoxDecoration(
                                              color: (taskPendingList[index]
                                                          .status ==
                                                      "pending")
                                                  ? pendingColor
                                                  : ((taskPendingList[index]
                                                              .status ==
                                                          "todo")
                                                      ? todoColor
                                                      : doneColor),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 20,
                                            child: ListView.builder(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: userListTask.length
                                                    .clamp(0, 3),
                                                itemBuilder: (context, index) {
                                                  return Stack(children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 4, right: 4),
                                                      width: 20,
                                                      height: 20,
                                                      decoration:
                                                          new BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                userListTask[
                                                                        index]
                                                                    .avatar),
                                                            fit: BoxFit.cover),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                  ]);
                                                }),
                                          ),
                                        ])),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    //Done Tabbar
                    Container(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: taskDoneList.length,
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
                                      taskId: taskDoneList[index].taskId,
                                      projectId: projectId),
                                ),
                              ).then((value) {
                                setState(() {
                                  taskAllList.clear();
                                  getTaskAllList();
                                });
                              });
                            },
                            child: AnimatedContainer(
                              width: 319,
                              height: 80,
                              decoration: BoxDecoration(
                                  color: purpleLight,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              margin: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8.0,
                                  left: appPaddingInApp,
                                  right: appPaddingInApp),
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 24, top: 12, bottom: 12, right: 24),
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
                                                taskDoneList[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16.0,
                                                    color: black,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                          Iconsax.calendar_1,
                                                          size: 16,
                                                          color: greyDark)),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    taskDoneList[index]
                                                        .deadline,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                    Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                          SizedBox(height: 8),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: new BoxDecoration(
                                              color: (index == 0)
                                                  ? doneColor
                                                  : ((index == 1)
                                                      ? todoColor
                                                      : pendingColor),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration:
                                                          new BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                // '${projects[index]!["background"]}'),
                                                                'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                                            fit: BoxFit.cover),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 14),
                                                      width: 20,
                                                      height: 20,
                                                      decoration:
                                                          new BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                // '${projects[index]!["background"]}'),
                                                                'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/74483881_541590829928084_9212411211595907072_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=174925&_nc_ohc=_BcQsQo3ihUAX_iFJNa&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8yxbwpnASSB_vCn5GyqKTnu7aK4_HSbDxGf6MLdvxBYA&oe=61DCB50E'),
                                                            fit: BoxFit.cover),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ])),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          (uid == idOwner)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => taskCreatingScreen(
                                    required,
                                    uid: uid,
                                    projectId: projectId),
                              ),
                            ).then((value) {
                              getTaskAllList();
                            });
                          },
                          child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              height: 42,
                              width: 132,
                              decoration: BoxDecoration(
                                color: purpleMain,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withOpacity(0.25),
                                    spreadRadius: 0,
                                    blurRadius: 64,
                                    offset: Offset(8, 8),
                                  ),
                                  BoxShadow(
                                    color: black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      child: Icon(Iconsax.add,
                                          size: 24, color: white)),
                                  SizedBox(width: 4),
                                  Text(
                                    "New Task",
                                    style: TextStyle(
                                        color: white,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ],
                              )),
                        )),
                    SizedBox(height: 50)
                  ],
                )
              : SizedBox(height: 50),
        ],
      ),
    );
  }
}
