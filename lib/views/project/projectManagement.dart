import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';
import 'package:grow_app/models/projectModel.dart';
import 'package:grow_app/models/userModel.dart';
import 'package:grow_app/views/dashboard/dashboardCenter.dart';

//import views
import 'package:grow_app/views/wrapper/navigationBar.dart';
import 'package:grow_app/views/project/projectCenter.dart';
import 'package:grow_app/views/project/projectCreating.dart';
import 'package:grow_app/views/project/projectDetail.dart';
import 'package:grow_app/views/project/projectSearching.dart';
import 'package:grow_app/views/profile/notificationCenter.dart';

//import controllers
import 'package:grow_app/controllers/projectController.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';

class projectManagementScreen extends StatefulWidget {
  String uid;

  projectManagementScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _projectManagementScreenState createState() =>
      _projectManagementScreenState(uid);
}

class _projectManagementScreenState extends State<projectManagementScreen> {
  // final String? uid = controllers.currentUserId;

  String uid = "";

  // List<String> projectsList = [];
  List projectIds = [];
  List projectsDataList = [];
  List<Map<String, dynamic>?> projects = [];

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
  List projectIdAll = [];
  List<Project> projectAllList = [];
  _projectManagementScreenState(uid);

  FirebaseAuth auth = FirebaseAuth.instance;
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
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    print('The current uid is $uid');
    getProjectsDataList();
    getAssignedProject();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List assigned = [];
  late UserModel user = UserModel(
      avatar: '',
      dob: '',
      tasksList: [],
      email: '',
      name: '',
      job: '',
      phonenumber: '',
      messagesList: [],
      projectsList: [],
      userId: '');
  List<UserModel> userList = [];
  Future getAssigned(String projectId) async {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .snapshots()
        .listen((value) {
      setState(() {
        assigned = value.data()!["assigned"];
        FirebaseFirestore.instance.collection("users").get().then((value) {
          setState(() {
            value.docs.forEach((element) {
              if (assigned.contains(element.data()['userId'] as String)) {
                userList.add(UserModel.fromDocument(element.data()));
              }
            });
            print("userList.length");
            print(userList.length);
          });
          setState(() {});
        });
      });
    });
  }

  getProjectsDataList() async {
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
                  IconButton(
                    padding: EdgeInsets.only(left: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios, size: 28, color: black),
                  ),
                  Spacer(),
                  Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  projectSearchingScreen(required, uid: uid),
                            ),
                          ).then((value) {
                            // getProjectsDataList();
                          });
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
                              child: Icon(Iconsax.search_normal_1,
                                  size: 18, color: white)),
                        ),
                      )),
                  SizedBox(width: 8),
                  Container(
                      padding: EdgeInsets.only(right: 28),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  notificationCenterScreen(required, uid: uid),
                            ),
                          );
                          // ).then((value) {
                          //   getProjectsDataList();
                          // });
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
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 28),
                child: Text(
                  "Projects",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 28.0,
                      color: black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.only(
                    left: appPaddingInApp, right: appPaddingInApp),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: projectAllList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => projectDetailScreen(required,
                                uid: uid,
                                projectId: projectAllList[index].projectId),
                          ),
                        ).then((value) {
                          getProjectsDataList();
                        });
                      },
                      child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 169,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    projectAllList[index].background),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                color: purpleHShadow.withOpacity(0.6),
                                spreadRadius: -16,
                                blurRadius: 24,
                                offset: Offset(0, 28),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(top: 16, bottom: 16.0),
                          child: Container(
                              padding: EdgeInsets.only(left: 24, right: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 235,
                                        child: Text(
                                          projectAllList[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 20.0,
                                              color: black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: new BoxDecoration(
                                          color:
                                              (projectAllList[index].status ==
                                                      "done")
                                                  ? doneColor
                                                  : ((projectAllList[index]
                                                              .status ==
                                                          "todo")
                                                      ? todoColor
                                                      : pendingColor),
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.topRight,
                                        height: 34,
                                        child: ListView.builder(
                                            // padding:
                                            //     EdgeInsets.only(right: 8),
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: userListProject.length
                                                .clamp(0, 3),
                                            itemBuilder: (context, index) {
                                              return Stack(children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  width: 34,
                                                  height: 34,
                                                  decoration: new BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            userListProject[
                                                                    index]
                                                                .avatar),
                                                        fit: BoxFit.cover),
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              ]);
                                            }),
                                      ),
                                      SizedBox(width: 24),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 16,
                                                width: 16,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          clockProject)),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Container(
                                                width: 137,
                                                child: Text(
                                                  projectAllList[index]
                                                      .deadline,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12.0,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 16,
                                                width: 16,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          taskProject)),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Container(
                                                width: 137,
                                                child: Text(
                                                  projectAllList[index]
                                                          .quantityTask +
                                                      " Task",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12.0,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                        width: 271,
                                        height: 9,
                                        decoration: BoxDecoration(
                                            color: white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16))),
                                      ),
                                      Container(
                                        width: (271 *
                                            0.01 *
                                            (double.parse(projectAllList[index]
                                                .progress))),
                                        height: 9,
                                        decoration: BoxDecoration(
                                            color:
                                                (projectAllList[index].status ==
                                                        "done")
                                                    ? doneColor
                                                    : ((projectAllList[index]
                                                                .status ==
                                                            "todo")
                                                        ? todoColor
                                                        : pendingColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16))),
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
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Spacer(),
                                    Text(
                                      projectAllList[index].progress + "%",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12.0,
                                          color: black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ])
                                ],
                              ))),
                    );
                  },
                ),
              ),
              SizedBox(height: 120)
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            projectCreatingScreen(required, uid: uid),
                      ),
                    ).then((value) {
                      // getProjectsDataList();
                    });
                  },
                  child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 300),
                      height: 42,
                      width: 148,
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
                              child: Icon(Iconsax.add, size: 24, color: white)),
                          SizedBox(width: 4),
                          Text(
                            "New Project",
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
      ],
    ));
  }
}

// child: FutureBuilder<List<String>>(
//   future: getProjectsDataList(),
//   builder: (context, snapshot) {
//     if (snapshot.hasData) {
//       return ListView.builder(
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         itemCount: snapshot.data!.length,
//         itemBuilder: (context, index) {
//           return FutureBuilder(
//               future: getDataProject(snapshot.data![index]),
//               builder: (context, snap) {
//                 print(snap.data);
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.purple,
//                     borderRadius: (index == 0)
//                         ? BorderRadius.only(
//                             topLeft: Radius.circular(16),
//                             topRight: Radius.circular(16))
//                         : ((index == snapshot.data!.length - 1)
//                             ? BorderRadius.only(
//                                 bottomLeft: Radius.circular(16),
//                                 bottomRight: Radius.circular(16))
//                             : BorderRadius.all(
//                                 Radius.circular(0))),
//                   ),
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     title: Text(
//                       "",
//                       style: TextStyle(
//                         fontFamily: "Poppins",
//                         fontSize: 18.0,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 );
//               });
//         },
//       );
//     } else if (snapshot.hasError) {
//       return CircularProgressIndicator();
//     } else {
//       return CircularProgressIndicator();
//     }
//   },
// ),

// Container(
//   padding: EdgeInsets.only(left: appPadding, right: appPadding),
//   child: StreamBuilder<QuerySnapshot>(
//     stream: FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('projects')
//         .snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return ListView.builder(
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             DocumentSnapshot ds = snapshot.data!.docs[index];
//             print(snapshot.data!.docs.first['name']);
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.purple,
//                 borderRadius: (index == 0)
//                     ? BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16))
//                     : ((index == snapshot.data!.docs.length - 1)
//                         ? BorderRadius.only(
//                             bottomLeft: Radius.circular(16),
//                             bottomRight: Radius.circular(16))
//                         : BorderRadius.all(Radius.circular(0))),
//               ),
//               margin: EdgeInsets.all(8.0),
//               child: ListTile(
//                 title: Text(
//                   ds['name'],
//                   style: TextStyle(
//                     fontFamily: "Poppins",
//                     fontSize: 18.0,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       } else if (snapshot.hasError) {
//         return CircularProgressIndicator();
//       } else {
//         return CircularProgressIndicator();
//       }
//     },
//   ),
// ),

// create project id
// String id = FirebaseFirestore.instance.collection("users").doc().id
// get document snapshot of project which have status field = todo
// await FirebaseFirestore.instance.collection("projects").where("status", isEqualTo: "todo").get().then((value) => null)
