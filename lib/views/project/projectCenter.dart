import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grow_app/models/taskModel.dart';
import 'package:grow_app/models/userModel.dart';
import 'package:grow_app/views/project/projectDetail.dart';
import 'package:grow_app/views/task/taskDetail.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';
import 'package:grow_app/models/projectModel.dart';

//import views
import 'package:grow_app/views/profile/notificationCenter.dart';
import 'package:grow_app/views/profile/profileCenter.dart';
import 'package:grow_app/views/project/projectDetail.dart';
import 'package:grow_app/views/project/projectManagement.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';
import 'package:custom_check_box/custom_check_box.dart';

class projectCenterScreen extends StatefulWidget {
  String uid;

  projectCenterScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _projectCenterScreenState createState() => _projectCenterScreenState(uid);
}

class _projectCenterScreenState extends State<projectCenterScreen>
    with SingleTickerProviderStateMixin {
  // final String? uid = controllers.currentUserId;

  String uid = "";
  String search = '';
  bool isExcecuted = false;
  var date = DateTime.now();

  _projectCenterScreenState(uid);

  TabController? _tabController;
  int _selectedIndex = 0;

  double _currentPosition = 1.0;

  bool checkBoxValue = false;

  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');

  List<Project> projectTodoList = [];
  List<Project> projectDoneList = [];
  List<Project> projectPendingList = [];
  List<Project> projectSearchList = [];
  List projectIds = [];

  // bool isChangeProjectData = false;
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
      messagesList: [],
      name: '',
      job: '',
      phonenumber: '',
      projectsList: [],
      tasksList: [],
      userId: '');
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
  List<Task> taskAllList = [];
  List taskAllId = [];
  late DateTime selectDate = DateTime.now();
  late DateTime selectDate2 = DateTime.now();

  Future getTaskAllList() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance
          .collection("tasks")
          .where('deadline',
              isEqualTo: "${DateFormat('yMMMMd').format(selectDate)}")
          .snapshots()
          .listen((value2) {
        setState(() {
          taskAllId = value1.data()!["tasksList"];
          print("${DateFormat('yMMMMd').format(selectDate)}");
          value2.docs.forEach((element) {
            // var check = taskAllList
            //     .where((element) => taskAllId.contains(element.taskId));
            // if (check.isEmpty) {
            if (taskAllId.contains(element.data()['taskId'] as String)) {
              taskAllList.add(Task.fromDocument(element.data()));
            }
          });

          // }
        });
      });
    });
  }

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

  getProjectTodoList() async {
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
        });
      });
    });
  }

  getProjectDoneList() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      print(projectIds);
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

  getProjectPendingList() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance
          .collection("projects")
          .where("status", isEqualTo: 'pending')
          .snapshots()
          .listen((value2) {
        setState(() {
          projectPendingList.clear();
          projectIds = value1.data()!["projectsList"];
          value2.docs.forEach((element) {
            if (projectIds.contains(element.data()['projectId'] as String)) {
              projectPendingList.add(Project.fromDocument(element.data()));
            }
          });
          print(projectPendingList.length);
        });
      });
    });
  }

  searchProjectName() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      setState(() {
        FirebaseFirestore.instance
            .collection("projects")
            .where("name", isGreaterThanOrEqualTo: search)
            .snapshots()
            .listen((value2) {
          projectIds = value1.data()!["projectsList"];
          setState(() {
            print('getProjectsIdList');
            value2.docs.forEach((element) {
              if (projectIds.contains(element.data()['projectId'] as String)) {
                projectSearchList.add(Project.fromDocument(element.data()));
              }
            });
            print(projectSearchList.length);
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
          FirebaseFirestore.instance
              .collection("projects")
              .doc(element)
              .snapshots()
              .listen((value2) {
            assignedProject = value2.data()!["assigned"];
            // setState(() {
            FirebaseFirestore.instance.collection("users").get().then((value3) {
              setState(() {
                userListProject.clear();
                value3.docs.forEach((element) {
                  if (assignedProject
                      .contains(element.data()['userId'] as String)) {
                    userListProject.add(UserModel.fromDocument(element.data()));
                  }
                });
              });
            });
            // });
          });
        });
        userListProject.clear();
      });
      print("task avatar ne");
      print(userListProject.length);
    });
  }

  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    print('The current uid is $uid');
    _tabController!.addListener(() {
      setState(() {
        _tabController != _tabController;
      });
      _selectedIndex = _tabController!.index;
      // print(_selectedIndex);
    });
    getProjectDoneList();
    getProjectPendingList();
    getProjectTodoList();
    getUserDetail();
    getTaskAllList();
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(height: 64),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 28),
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
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16.0,
                              color: black,
                              fontWeight: FontWeight.w600,
                              height: 1.0),
                        ),
                        SizedBox(height: 4),
                        Text(
                          user.job,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 10.0,
                              color: greyDark,
                              fontWeight: FontWeight.w400,
                              height: 1.0),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                        padding: EdgeInsets.only(right: 28),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => notificationCenterScreen(
                                    required,
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
                            child: Container(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                child: Icon(Iconsax.notification,
                                    size: 18, color: white)),
                          ),
                        )),
                  ],
                ),
                // SizedBox(height: 24),
                // Container(
                //   alignment: Alignment.center,
                //   child: Form(
                //     // key: formKey,
                //     child: Container(
                //       width: 280,
                //       height: 40,
                //       padding: EdgeInsets.only(left: 2, right: 24),
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(8),
                //           color: purpleLight),
                //       alignment: Alignment.topCenter,
                //       child: TextFormField(
                //           style: TextStyle(
                //               fontFamily: 'Poppins',
                //               fontSize: 14,
                //               color: black,
                //               fontWeight: FontWeight.w400),
                //           controller: searchController,
                //           keyboardType: TextInputType.text,
                //           onChanged: (val) {
                //             search = val;
                //             // searchProjectName();
                //           },
                //           decoration: InputDecoration(
                //             prefixIcon: Container(
                //                 child: Stack(
                //                     alignment: Alignment.center,
                //                     children: [
                //                   Icon(Iconsax.search_normal_1,
                //                       size: 20, color: black)
                //                 ])),
                //             border: InputBorder.none,
                //             hintText: "What are you looking for?",
                //             hintStyle: TextStyle(
                //                 fontFamily: 'Poppins',
                //                 fontSize: 14,
                //                 color: greyDark,
                //                 fontWeight: FontWeight.w400),
                //           )),
                //     ),
                //   ),
                // ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.only(left: 28, right: 28),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Project",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24.0,
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
                                  builder: (context) => projectManagementScreen(
                                      required,
                                      uid: uid),
                                ),
                              );
                            },
                            child: Text(
                              "View all",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: greyDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            )),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  child: TabBar(
                    controller: _tabController,
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: greyDark,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),

                    // indicator: UnderlineTabIndicator(
                    //   borderSide: BorderSide(color: blackLight, width: 0.0),
                    // ),
                    //For Indicator Show and Customization
                    // indicatorColor: purpleMain,
                    labelPadding: EdgeInsets.symmetric(horizontal: 12),
                    padding:
                        EdgeInsets.only(left: 14, right: 0, top: 0, bottom: 0),
                    isScrollable: true,
                    onTap: (value) {
                      setState(() {
                        _tabController != _tabController;
                      });
                    },
                    tabs: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            width: 50,
                            child: new Tab(
                                text: 'To do',
                                height: (_selectedIndex == 0) ? 40 : 40),
                          ),
                          (_selectedIndex == 0)
                              ? Container(
                                  width: 6,
                                  height: 6,
                                  decoration: new BoxDecoration(
                                    color: black,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : SizedBox(height: 6),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            width: 95.0,
                            child: new Tab(
                                text: 'Pending',
                                height: (_selectedIndex == 1) ? 40 : 40),
                          ),
                          (_selectedIndex == 1)
                              ? Container(
                                  width: 6,
                                  height: 6,
                                  decoration: new BoxDecoration(
                                    color: black,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : SizedBox(height: 6),
                        ],
                      ),

                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            width: 50,
                            child: new Tab(
                                text: 'Done',
                                height: (_selectedIndex == 2) ? 40 : 40),
                          ),
                          (_selectedIndex == 2)
                              ? Container(
                                  width: 6,
                                  height: 6,
                                  decoration: new BoxDecoration(
                                    color: black,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : SizedBox(height: 6),
                        ],
                      ),
                      // Tab(text: 'In progress'),
                      // Tab(text: "To do"),
                      // Tab(text: "Done")
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: double.maxFinite,
                  height: 169,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Container(
                      //  height: 169,
                      //  width: 267,
                      //  padding: EdgeInsets.only(left: 2, right: 24),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     color: purpleLight
                      //   ),
                      // ),

                      Container(
                          height: 169,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: PageView.builder(
                              controller: PageController(
                                  initialPage: 0,
                                  keepPage: true,
                                  viewportFraction: 0.85),
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (num) {
                                setState(() {
                                  if (num + 1 == projectTodoList.length) {
                                    _currentPosition = 2.0;
                                  } else if (num == 0) {
                                    _currentPosition = 0.0;
                                  } else {
                                    _currentPosition = num.toDouble();
                                  }
                                });
                              },
                              itemCount: projectTodoList.length,
                              itemBuilder: (context, index) {
                                // return Container(
                                //   margin:
                                //       EdgeInsets.symmetric(horizontal: 14.0),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20.0),
                                //     image: DecorationImage(
                                //         image: AssetImage(_listImageInprogress[index]),
                                //         fit: BoxFit.contain),
                                //   ),
                                // );
                                return Padding(
                                  padding: EdgeInsets.only(right: 50),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              projectDetailScreen(
                                                  required,
                                                  uid: uid,
                                                  projectId:
                                                      projectTodoList[index]
                                                          .projectId),
                                        ),
                                      ).then((value) {
                                        // getProjectsDataList();
                                      });
                                    },
                                    child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        width: 267,
                                        height: 169,
                                        // margin: EdgeInsets.only(right: 50),
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   // image: NetworkImage(
                                          //   //     '${projects[index]!["background"]}'),
                                          //   image: NetworkImage('https://i.imgur.com/h59jgEn.png'),
                                          //   fit: BoxFit.cover
                                          // ),
                                          color: purpleLight,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: purpleHShadow
                                                  .withOpacity(0.6),
                                              spreadRadius: -16,
                                              blurRadius: 24,
                                              offset: Offset(0, 28),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                top: 20,
                                                left: 16,
                                                bottom: 12,
                                                right: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // SizedBox(height: 16),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 198,
                                                      child: Text(
                                                        // "${projects[index]!["name"]}",
                                                        projectTodoList[index]
                                                            .name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 16.0,
                                                            color: black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: (projectTodoList[
                                                                        index]
                                                                    .status ==
                                                                "done")
                                                            ? doneColor
                                                            : ((projectTodoList[
                                                                            index]
                                                                        .status ==
                                                                    "todo")
                                                                ? todoColor
                                                                : pendingColor),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 12),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Container(
                                                    //   child: Row(
                                                    //     children: [
                                                    //       Stack(
                                                    //         children: [
                                                    //           Container(
                                                    //             width: 32,
                                                    //             height: 32,
                                                    //             decoration:
                                                    //                 new BoxDecoration(
                                                    //               image: DecorationImage(
                                                    //                   image: NetworkImage(
                                                    //                       // '${projects[index]!["background"]}'),
                                                    //                       projectTodoList[index].background),
                                                    //                   fit: BoxFit.cover),
                                                    //               shape: BoxShape
                                                    //                   .circle,
                                                    //             ),
                                                    //           ),
                                                    //           Container(
                                                    //             margin: EdgeInsets
                                                    //                 .only(
                                                    //                     left:
                                                    //                         22),
                                                    //             width: 32,
                                                    //             height: 32,
                                                    //             decoration:
                                                    //                 new BoxDecoration(
                                                    //               image: DecorationImage(
                                                    //                   image:
                                                    //                       NetworkImage(
                                                    //                           // '${projects[index]!["background"]}'),
                                                    //                           'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                                    //                   fit: BoxFit
                                                    //                       .cover),
                                                    //               shape: BoxShape
                                                    //                   .circle,
                                                    //             ),
                                                    //           ),
                                                    //           Container(
                                                    //             margin: EdgeInsets
                                                    //                 .only(
                                                    //                     left:
                                                    //                         44),
                                                    //             width: 32,
                                                    //             height: 32,
                                                    //             decoration:
                                                    //                 new BoxDecoration(
                                                    //               image: DecorationImage(
                                                    //                   image:
                                                    //                       NetworkImage(
                                                    //                           // '${projects[index]!["background"]}'),
                                                    //                           'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                                    //                   fit: BoxFit
                                                    //                       .cover),
                                                    //               shape: BoxShape
                                                    //                   .circle,
                                                    //             ),
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    // SizedBox(width: 24),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 16,
                                                              width: 16,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        clockProject)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Container(
                                                              width: 112,
                                                              child: Text(
                                                                // "${projects[index]!["deadline"]}",
                                                                projectTodoList[
                                                                        index]
                                                                    .deadline,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontSize:
                                                                        12.0,
                                                                    color:
                                                                        black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 16,
                                                              width: 16,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        taskProject)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Container(
                                                              width: 112,
                                                              child: Text(
                                                                // "${projects[index]!["quantityTask"]} task",
                                                                projectTodoList[
                                                                            index]
                                                                        .quantityTask +
                                                                    " task",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontSize:
                                                                        12.0,
                                                                    color:
                                                                        black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 18),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 235,
                                                      height: 9,
                                                      decoration: BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: black
                                                                .withOpacity(
                                                                    0.25),
                                                            spreadRadius: 0,
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: (271 *
                                                          0.01 *
                                                          // (double.parse(
                                                          //     projects[index]!["progress"]))
                                                          double.parse(
                                                              projectTodoList[
                                                                      index]
                                                                  .progress)),
                                                      height: 9,
                                                      decoration: BoxDecoration(
                                                        color: (projectTodoList[
                                                                        index]
                                                                    .status ==
                                                                "done")
                                                            ? doneColor
                                                            : ((projectTodoList[
                                                                            index]
                                                                        .status ==
                                                                    "todo")
                                                                ? todoColor
                                                                : pendingColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: black
                                                                .withOpacity(
                                                                    0.25),
                                                            spreadRadius: 0,
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(children: [
                                                  Text(
                                                    "Progress",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 12.0,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    // "${projects[index]!["progress"]}%",
                                                    projectTodoList[index]
                                                            .progress +
                                                        " %",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 12.0,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ])
                                              ],
                                            ))),
                                  ),
                                );
                              })),
                      Container(
                          height: 169,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: PageView.builder(
                              controller: PageController(
                                  initialPage: 0,
                                  keepPage: true,
                                  viewportFraction: 0.85),
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (num) {
                                setState(() {
                                  if (num + 1 == projectPendingList.length) {
                                    _currentPosition = 2.0;
                                  } else if (num == 0) {
                                    _currentPosition = 0.0;
                                  } else {
                                    _currentPosition = num.toDouble();
                                  }
                                });
                              },
                              itemCount: projectPendingList.length,
                              itemBuilder: (context, index) {
                                // return Container(
                                //   margin:
                                //       EdgeInsets.symmetric(horizontal: 14.0),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20.0),
                                //     image: DecorationImage(
                                //         image: AssetImage(_listImageInprogress[index]),
                                //         fit: BoxFit.contain),
                                //   ),
                                // );
                                return Padding(
                                  padding: EdgeInsets.only(right: 50),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              projectDetailScreen(
                                                  required,
                                                  uid: uid,
                                                  projectId:
                                                      projectPendingList[index]
                                                          .projectId),
                                        ),
                                      ).then((value) {
                                        // getProjectsDataList();
                                      });
                                    },
                                    child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        width: 267,
                                        height: 169,
                                        // margin: EdgeInsets.only(right: 50),
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   // image: NetworkImage(
                                          //   //     '${projects[index]!["background"]}'),
                                          //   image: NetworkImage('https://i.imgur.com/h59jgEn.png'),
                                          //   fit: BoxFit.cover
                                          // ),
                                          color: purpleLight,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: purpleHShadow
                                                  .withOpacity(0.6),
                                              spreadRadius: -16,
                                              blurRadius: 24,
                                              offset: Offset(0, 28),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                top: 20,
                                                left: 16,
                                                bottom: 12,
                                                right: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // SizedBox(height: 16),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 198,
                                                      child: Text(
                                                        // "${projects[index]!["name"]}",
                                                        projectPendingList[
                                                                index]
                                                            .name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 16.0,
                                                            color: black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: (projectPendingList[
                                                                        index]
                                                                    .status ==
                                                                "done")
                                                            ? doneColor
                                                            : ((projectPendingList[
                                                                            index]
                                                                        .status ==
                                                                    "todo")
                                                                ? todoColor
                                                                : pendingColor),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 12),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Container(
                                                    //   alignment:
                                                    //       Alignment.topRight,
                                                    //   height: 34,
                                                    //   child: ListView.builder(
                                                    //       // padding:
                                                    //       //     EdgeInsets.only(right: 8),
                                                    //       physics:
                                                    //           const AlwaysScrollableScrollPhysics(),
                                                    //       shrinkWrap: true,
                                                    //       scrollDirection:
                                                    //           Axis.horizontal,
                                                    //       itemCount:
                                                    //           userListProject
                                                    //               .length
                                                    //               .clamp(0, 3),
                                                    //       itemBuilder:
                                                    //           (context, index) {
                                                    //         return Stack(
                                                    //             children: [
                                                    //               Container(
                                                    //                 margin: EdgeInsets
                                                    //                     .only(
                                                    //                         left:
                                                    //                             0),
                                                    //                 width: 34,
                                                    //                 height: 34,
                                                    //                 decoration:
                                                    //                     new BoxDecoration(
                                                    //                   image: DecorationImage(
                                                    //                       image: NetworkImage(userListProject[index]
                                                    //                           .avatar),
                                                    //                       fit: BoxFit
                                                    //                           .cover),
                                                    //                   shape: BoxShape
                                                    //                       .circle,
                                                    //                 ),
                                                    //               )
                                                    //             ]);
                                                    //       }),
                                                    // ),
                                                    // SizedBox(width: 24),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 16,
                                                              width: 16,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        clockProject)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Container(
                                                              width: 112,
                                                              child: Text(
                                                                // "${projects[index]!["deadline"]}",
                                                                projectPendingList[
                                                                        index]
                                                                    .deadline,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontSize:
                                                                        12.0,
                                                                    color:
                                                                        black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 16,
                                                              width: 16,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        taskProject)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Container(
                                                              width: 112,
                                                              child: Text(
                                                                // "${projects[index]!["quantityTask"]} task",
                                                                projectPendingList[
                                                                            index]
                                                                        .quantityTask +
                                                                    " task",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontSize:
                                                                        12.0,
                                                                    color:
                                                                        black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 18),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 235,
                                                      height: 9,
                                                      decoration: BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: black
                                                                .withOpacity(
                                                                    0.25),
                                                            spreadRadius: 0,
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: (271 *
                                                          0.01 *
                                                          // (double.parse(
                                                          //     projects[index]!["progress"]))
                                                          double.parse(
                                                              projectPendingList[
                                                                      index]
                                                                  .progress)),
                                                      height: 9,
                                                      decoration: BoxDecoration(
                                                        color: (projectPendingList[
                                                                        index]
                                                                    .status ==
                                                                "done")
                                                            ? doneColor
                                                            : ((projectPendingList[
                                                                            index]
                                                                        .status ==
                                                                    "todo")
                                                                ? todoColor
                                                                : pendingColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: black
                                                                .withOpacity(
                                                                    0.25),
                                                            spreadRadius: 0,
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(children: [
                                                  Text(
                                                    "Progress",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 12.0,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    // "${projects[index]!["progress"]}%",
                                                    projectPendingList[index]
                                                            .progress +
                                                        " %",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 12.0,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ])
                                              ],
                                            ))),
                                  ),
                                );
                              })),
                      Container(
                          height: 169,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: PageView.builder(
                              controller: PageController(
                                  initialPage: 0,
                                  keepPage: true,
                                  viewportFraction: 0.85),
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (num) {
                                setState(() {
                                  if (num + 1 == projectDoneList.length) {
                                    _currentPosition = 2.0;
                                  } else if (num == 0) {
                                    _currentPosition = 0.0;
                                  } else {
                                    _currentPosition = num.toDouble();
                                  }
                                });
                              },
                              itemCount: projectDoneList.length,
                              itemBuilder: (context, index) {
                                // return Container(
                                //   margin:
                                //       EdgeInsets.symmetric(horizontal: 14.0),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20.0),
                                //     image: DecorationImage(
                                //         image: AssetImage(_listImageInprogress[index]),
                                //         fit: BoxFit.contain),
                                //   ),
                                // );
                                return Padding(
                                  padding: EdgeInsets.only(right: 50),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              projectDetailScreen(
                                                  required,
                                                  uid: uid,
                                                  projectId:
                                                      projectDoneList[index]
                                                          .projectId),
                                        ),
                                      ).then((value) {
                                        // getProjectsDataList();
                                      });
                                    },
                                    child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        width: 267,
                                        height: 169,
                                        // margin: EdgeInsets.only(right: 50),
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   // image: NetworkImage(
                                          //   //     '${projects[index]!["background"]}'),
                                          //   image: NetworkImage('https://i.imgur.com/h59jgEn.png'),
                                          //   fit: BoxFit.cover
                                          // ),
                                          color: purpleLight,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: purpleHShadow
                                                  .withOpacity(0.6),
                                              spreadRadius: -16,
                                              blurRadius: 24,
                                              offset: Offset(0, 28),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                top: 20,
                                                left: 16,
                                                bottom: 12,
                                                right: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // SizedBox(height: 16),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 198,
                                                      child: Text(
                                                        // "${projects[index]!["name"]}",
                                                        projectDoneList[index]
                                                            .name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 16.0,
                                                            color: black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: (projectDoneList[
                                                                        index]
                                                                    .status ==
                                                                "done")
                                                            ? doneColor
                                                            : ((projectDoneList[
                                                                            index]
                                                                        .status ==
                                                                    "todo")
                                                                ? todoColor
                                                                : pendingColor),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 12),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Container(
                                                    //   child: Row(
                                                    //     children: [
                                                    //       Stack(
                                                    //         children: [
                                                    //           Container(
                                                    //             width: 32,
                                                    //             height: 32,
                                                    //             decoration:
                                                    //                 new BoxDecoration(
                                                    //               image: DecorationImage(
                                                    //                   image:
                                                    //                       NetworkImage(
                                                    //                           // '${projects[index]!["background"]}'),
                                                    //                           'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                                    //                   fit: BoxFit
                                                    //                       .cover),
                                                    //               shape: BoxShape
                                                    //                   .circle,
                                                    //             ),
                                                    //           ),
                                                    //           Container(
                                                    //             margin: EdgeInsets
                                                    //                 .only(
                                                    //                     left:
                                                    //                         22),
                                                    //             width: 32,
                                                    //             height: 32,
                                                    //             decoration:
                                                    //                 new BoxDecoration(
                                                    //               image: DecorationImage(
                                                    //                   image:
                                                    //                       NetworkImage(
                                                    //                           // '${projects[index]!["background"]}'),
                                                    //                           'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                                    //                   fit: BoxFit
                                                    //                       .cover),
                                                    //               shape: BoxShape
                                                    //                   .circle,
                                                    //             ),
                                                    //           ),
                                                    //           Container(
                                                    //             margin: EdgeInsets
                                                    //                 .only(
                                                    //                     left:
                                                    //                         44),
                                                    //             width: 32,
                                                    //             height: 32,
                                                    //             decoration:
                                                    //                 new BoxDecoration(
                                                    //               image: DecorationImage(
                                                    //                   image:
                                                    //                       NetworkImage(
                                                    //                           // '${projects[index]!["background"]}'),
                                                    //                           'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                                    //                   fit: BoxFit
                                                    //                       .cover),
                                                    //               shape: BoxShape
                                                    //                   .circle,
                                                    //             ),
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    // SizedBox(width: 24),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 16,
                                                              width: 16,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        clockProject)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Container(
                                                              width: 112,
                                                              child: Text(
                                                                // "${projects[index]!["deadline"]}",
                                                                projectDoneList[
                                                                        index]
                                                                    .deadline,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontSize:
                                                                        12.0,
                                                                    color:
                                                                        black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 16,
                                                              width: 16,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        taskProject)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Container(
                                                              width: 112,
                                                              child: Text(
                                                                // "${projects[index]!["quantityTask"]} task",
                                                                projectDoneList[
                                                                            index]
                                                                        .quantityTask +
                                                                    " task",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontSize:
                                                                        12.0,
                                                                    color:
                                                                        black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 18),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 235,
                                                      height: 9,
                                                      decoration: BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: black
                                                                .withOpacity(
                                                                    0.25),
                                                            spreadRadius: 0,
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: (271 *
                                                          0.01 *
                                                          // (double.parse(
                                                          //     projects[index]!["progress"]))
                                                          double.parse(
                                                              projectDoneList[
                                                                      index]
                                                                  .progress)),
                                                      height: 9,
                                                      decoration: BoxDecoration(
                                                        color: (projectDoneList[
                                                                        index]
                                                                    .status ==
                                                                "done")
                                                            ? doneColor
                                                            : ((projectDoneList[
                                                                            index]
                                                                        .status ==
                                                                    "todo")
                                                                ? todoColor
                                                                : pendingColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: black
                                                                .withOpacity(
                                                                    0.25),
                                                            spreadRadius: 0,
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(children: [
                                                  Text(
                                                    "Progress",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 12.0,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    // "${projects[index]!["progress"]}%",
                                                    projectDoneList[index]
                                                            .progress +
                                                        " %",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 12.0,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ])
                                              ],
                                            ))),
                                  ),
                                );
                              })),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.only(left: 28, right: 28),
                  child: Text(
                    "Daily task",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 24.0,
                      color: black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 12),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                        padding:
                                                            EdgeInsets.zero,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                            Iconsax.calendar_1,
                                                            size: 16,
                                                            color: greyDark)),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      taskAllList[index]
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
                                                color: (taskAllList[index]
                                                            .status ==
                                                        "todo")
                                                    ? todoColor
                                                    : ((taskAllList[index]
                                                                .status ==
                                                            "done")
                                                        ? doneColor
                                                        : pendingColor),
                                                shape: BoxShape.circle,
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
              ]))
        ],
      ),
    );
  }
}
