import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grow_app/models/projectModel.dart';
import 'package:grow_app/models/userModel.dart';

//import widgets
import 'package:grow_app/views/widget/dialogWidget.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';

//import views
import 'package:grow_app/views/profile/notificationCenter.dart';
import 'package:grow_app/views/dashboard/circleProgressDashboard.dart';
import 'package:grow_app/views/project/projectManagement.dart';
import 'package:grow_app/views/project/projectDetail.dart';
import 'package:grow_app/views/profile/profileCenter.dart';
// import 'package:grow_app/views/dashboard/projecrCard.dart';

//import firebase
import 'package:firebase_auth/firebase_auth.dart';

//import others
import 'package:blur/blur.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image/flutter_image.dart';

class dashboardCenterScreen extends StatefulWidget {
  String uid;

  dashboardCenterScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _dashboardCenterScreenState createState() => _dashboardCenterScreenState(uid);
}

class _dashboardCenterScreenState extends State<dashboardCenterScreen>
    with SingleTickerProviderStateMixin {
  String uid = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  _dashboardCenterScreenState(uid);

  List<Project> projectTodoList = [];
  List<Project> projectAllList = [];
  List<Project> projectDoneList = [];
  List<Project> projectPendingList = [];

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
      dob: '',
      email: '',
      name: '',
      job: '',
      messagesList: [],
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
      user = UserModel.fromDocument(value.docs.first.data());
    });
  }

  Future getProjectAllList() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance
          .collection("projects")
          .orderBy('deadline', descending: true)
          .snapshots()
          .listen((value2) {
        setState(() {
          projectAllList.clear();
          projectIdAll = value1.data()!["projectsList"];
          value2.docs.forEach((element) {
            if (projectIdAll.contains(element.data()["projectId"] as String)) {
              projectAllList.add(Project.fromDocument(element.data()));
            }
          });
        });
      });
    });
  }

  Future getProjectTodoList() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      print(projectIds);
      FirebaseFirestore.instance
          .collection("projects")
          .where("status", isEqualTo: 'todo')
          .snapshots()
          .listen((value2) {
        setState(() {
          projectTodoList.clear();
          projectIds = value1.data()!["projectsList"];
          value2.docs.forEach((element) {
            if (projectIds.contains(element.data()['projectId'] as String)) {
              projectTodoList.add(Project.fromDocument(element.data()));
            }
          });
          print(projectTodoList.length);
        });
      });
    });
  }

  Future getProjectDoneList() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance
          .collection("projects")
          .where("status", isEqualTo: 'done')
          .snapshots()
          .listen((value2) {
        setState(() {
          projectDoneList.clear();
          projectIds = value1.data()!["projectsList"];
          value2.docs.forEach((element) {
            if (projectIds.contains(element.data()['projectId'] as String)) {
              projectDoneList.add(Project.fromDocument(element.data()));
            }
          });
        });
      });
    });
  }

  Future getProjectPendingList() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      print(projectIds);
      FirebaseFirestore.instance
          .collection("projects")
          .where("status", isEqualTo: 'pending')
          .snapshots()
          .listen((value2) {
        setState(() {
          projectPendingList.clear();
          projectIds = value1.data()!["projectsList"];
          print('getProjectsIdList');
          value2.docs.forEach((element) {
            if (projectIds.contains(element.data()['projectId'] as String)) {
              projectPendingList.add(Project.fromDocument(element.data()));
            }
          });
        });
      });
    });
  }

  late List projectList = [];
  late List assignedProject = [];
  late List<UserModel> userListProject = [];

  Future getAssignedProject() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      setState(() {
        projectList = value1.data()!["projectsList"];
        projectList.forEach((element) {
          setState(() {
            FirebaseFirestore.instance
                .collection("projects")
                .doc(element)
                .snapshots()
                .listen((value2) {
              assignedProject = value2.data()!["assigned"];
              // setState(() {
              FirebaseFirestore.instance
                  .collection("users")
                  .get()
                  .then((value3) {
                setState(() {
                  userListProject.clear();
                  value3.docs.forEach((element) {
                    if (assignedProject
                        .contains(element.data()['userId'] as String)) {
                      userListProject
                          .add(UserModel.fromDocument(element.data()));
                    }
                  });
                });
              });
              // });
            });
          });
        });
      });
      print("task avatar ne");
      print(userListProject.length);
    });
  }

  late AnimationController _animatedController;
  late Animation<double> _animationDone;
  late Animation<double> _animationTodo;
  late Animation<double> _animationPending;
  late Tween<double> _tweenDone;
  late Tween<double> _tweenTodo;
  late Tween<double> _tweenPending;
  late double doneValue = 0;
  late double todoValue = 0;
  late double pendingValue = 0;
  bool showChart = false;

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;

    _animatedController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

    _tweenDone = Tween<double>(begin: 0, end: doneValue);
    _animationDone = _tweenDone.animate(_animatedController)
      ..addListener(() {
        setState(() {});
      });

    _tweenTodo = Tween<double>(begin: doneValue, end: todoValue);
    _animationTodo = _tweenTodo.animate(_animatedController)
      ..addListener(() {
        setState(() {});
      });

    _tweenPending = Tween<double>(begin: todoValue, end: pendingValue);
    _animationPending = _tweenPending.animate(_animatedController)
      ..addListener(() {
        setState(() {});
      });

    getProjectAllList();
    getProjectDoneList();
    getProjectTodoList();
    getProjectPendingList();
    getUserDetail();
    getAssignedProject();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgroundBasic), fit: BoxFit.cover),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(
                      top: appPaddingInApp,
                      left: appPaddingInApp,
                      right: appPaddingInApp),
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
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              profileCenterScreen(required,
                                                  uid: uid),
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
                                        image: DecorationImage(
                                            image: NetworkImage(user.avatar),
                                            fit: BoxFit.cover),
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
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Poppins',
                            color: black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            SizedBox(width: 8),
                            CustomPaint(
                              foregroundPainter: circleProgressDashboard(
                                  _animationDone.value,
                                  _animationTodo.value,
                                  _animationPending.value),
                              child: Container(
                                  width: 160,
                                  height: 160,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        doneValue = ((projectDoneList.length /
                                                projectAllList.length) *
                                            100);
                                        todoValue = ((projectDoneList.length /
                                                    projectAllList.length) *
                                                100) +
                                            ((projectTodoList.length /
                                                    projectAllList.length) *
                                                100);
                                        pendingValue =
                                            ((projectDoneList.length /
                                                        projectAllList.length) *
                                                    100) +
                                                ((projectTodoList.length /
                                                        projectAllList.length) *
                                                    100) +
                                                ((projectPendingList.length /
                                                        projectAllList.length) *
                                                    100);
                                        print(
                                            "doneValue" + doneValue.toString());
                                        print(
                                            "todoValue" + todoValue.toString());
                                        print("pendingValue" +
                                            pendingValue.toString());
                                        _animatedController.reset();
                                        if (showChart == true) {
                                          _tweenDone.begin = 0;
                                          _tweenDone.end = 0;
                                          _tweenTodo.begin = 0;
                                          _tweenTodo.end = 0;
                                          _tweenPending.begin = 0;
                                          _tweenPending.end = 0;
                                          _animatedController.reverse();
                                          showChart = false;
                                        } else {
                                          _tweenDone.begin = 0;
                                          _tweenDone.end = doneValue;
                                          _tweenTodo.begin = doneValue;
                                          _tweenTodo.end = todoValue;
                                          _tweenPending.begin = todoValue;
                                          _tweenPending.end = pendingValue;
                                          _animatedController.forward();
                                          showChart = true;
                                        }
                                      });
                                    },
                                    child: Center(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              projectAllList.length.toString(),
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontFamily: 'Poppins',
                                                color: black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'Total Project',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                color: greyDark,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            Spacer(),
                            Container(
                              child: Column(
                                // padding: EdgeInsets.only(right: 20),
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 64,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(right: 8),
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                    color: doneColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  )),
                                              Spacer(),
                                              Text(
                                                ((projectAllList.length == 0)
                                                    ? ("0 %")
                                                    : ((projectDoneList.length /
                                                                    projectAllList
                                                                        .length) *
                                                                100)
                                                            .toStringAsFixed(0)
                                                            .toString() +
                                                        "%"),
                                                // projectDoneList.length.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                  color: black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Done',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            color: greyDark,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 64,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(right: 8),
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                    color: todoColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  )),
                                              Spacer(),
                                              Text(
                                                ((projectAllList.length == 0)
                                                    ? ("0 %")
                                                    : ((projectTodoList.length /
                                                                    projectAllList
                                                                        .length) *
                                                                100)
                                                            .toStringAsFixed(0)
                                                            .toString() +
                                                        "%"),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                  color: black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'To do',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            color: greyDark,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 64,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(right: 8),
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                    color: pendingColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  )),
                                              Spacer(),
                                              Text(
                                                ((projectAllList.length == 0)
                                                    ? ("0 %")
                                                    : ((projectPendingList
                                                                        .length /
                                                                    projectAllList
                                                                        .length) *
                                                                100)
                                                            .toStringAsFixed(0)
                                                            .toString() +
                                                        "%"),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                  color: black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Pending',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            color: greyDark,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 24),
                          ],
                        ),
                        SizedBox(height: 24),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Recent Project",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20.0,
                                  color: black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.only(bottom: 2),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              projectManagementScreen(required,
                                                  uid: uid),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View all",
                                      // textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: greyDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    )),
                              ),
                              SizedBox(width: 2)
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        Container(
                          height: 376-31,
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            child: Column(
                              // padding: EdgeInsets.only(
                              //     left: appPaddingInApp, right: appPaddingInApp),
                              children: [
                                GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: (151 / 160),
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  // scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: projectAllList.length.clamp(0, 4),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                projectDetailScreen(
                                              required,
                                              uid: uid,
                                              projectId: projectAllList[index]
                                                  .projectId,
                                            ),
                                          ),
                                        ).then((value) {
                                          // getProjectAllList();
                                        });
                                      },
                                      child: AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          width: 151,
                                          height: 160,
                                          padding: EdgeInsets.only(
                                              top: 16,
                                              left: 16,
                                              right: 12,
                                              bottom: 12),
                                          decoration: BoxDecoration(
                                              color: purpleLight,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  projectAllList[index]
                                                      .deadline,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: 'Poppins',
                                                    color: black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                width: 86,
                                                child: Text(
                                                  projectAllList[index].name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    color: black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                width: 119,
                                                child: Text(
                                                  projectAllList[index]
                                                      .description,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: 'Poppins',
                                                    color: black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 86,
                                                    height: 7,
                                                    decoration: BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                  ),
                                                  Container(
                                                    width: (double.parse(
                                                            projectAllList[
                                                                    index]
                                                                .progress) *
                                                        0.01 *
                                                        100),
                                                    height: 7,
                                                    decoration: BoxDecoration(
                                                        color: doneColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Container(
                                                alignment: Alignment.topRight,
                                                height: 20,
                                                child: ListView.builder(
                                                    // padding:
                                                    //     EdgeInsets.only(right: 8),
                                                    physics:
                                                        const AlwaysScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: userListProject
                                                        .length
                                                        .clamp(0, 3),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Stack(children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 0),
                                                          width: 20,
                                                          height: 20,
                                                          decoration:
                                                              new BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    userListProject[
                                                                            index]
                                                                        .avatar),
                                                                fit: BoxFit
                                                                    .cover),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        )
                                                      ]);
                                                    }),
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                ),
                                SizedBox(height: 96)
                              ],
                            ),
                          ),
                        )
                      ]))
            ])));
  }
}
