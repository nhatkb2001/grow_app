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
import 'package:grow_app/models/projectModel.dart';
import 'package:grow_app/views/project/projectDetail.dart';
import 'package:grow_app/views/project/projectManagement.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';

class projectSearchingScreen extends StatefulWidget {
  String uid;

  projectSearchingScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _projectSearchingScreenState createState() =>
      _projectSearchingScreenState(uid);
}

class _projectSearchingScreenState extends State<projectSearchingScreen> {
  // final String? uid = controllers.currentUserId;
  String uid = "";
  String search = '';
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
  List<Project> projectSearchList = [];
  List<Project> projectAllList = [];

  _projectSearchingScreenState(uid);

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');
  late String task;

  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  searchProjectName() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance
          .collection("projects")
          .where("name", isGreaterThanOrEqualTo: search)
          .where("name", isLessThanOrEqualTo: search + "z")
          .snapshots()
          .listen((value2) {
        setState(() {
          projectIds = value1.data()!["projectsList"];
          projectSearchList.clear();
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
  }

  Future getProjectAllList() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((value1) {
      projectIdAll = value1.data()!["projectsList"];
      FirebaseFirestore.instance
          .collection("projects")
          .snapshots()
          .listen((value2) {
        setState(() {
          projectIdAll = value1.data()!["projectsList"];
          projectAllList.clear();
          value2.docs.forEach((element) {
            if (projectIdAll.contains(element.data()["projectId"] as String)) {
              projectAllList.add(Project.fromDocument(element.data()));
            }
          });
          print(projectAllList.length);
        });
      });
    });
  }

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    print('The current uid is $uid');
    getProjectAllList();
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
                            onChanged: (val) {
                              (val == '')
                                  ? setState(() {
                                      projectSearchList.clear();
                                    })
                                  : search = val;
                              setState(() {
                                searchProjectName();
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                    Icon(Iconsax.search_normal_1,
                                        size: 20, color: black)
                                  ])),
                              border: InputBorder.none,
                              hintText: "What are you looking for?",
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
                  itemCount: projectSearchList.length,
                  // itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => projectDetailScreen(required,
                                uid: uid,
                                projectId: projectSearchList[index].projectId),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 169,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                // image: NetworkImage(
                                //     '${projects[index]!["background"]}'),
                                image: NetworkImage(
                                    projectSearchList[index].background),
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
                                          // "${projects[index]!["name"]}",
                                          projectSearchList[index].name,
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
                                          // color: (projects[index]!["status"] ==
                                          //         "done")
                                          //     ? doneColor
                                          //     : ((projects[index]!["status"] ==
                                          //             "todo")
                                          //         ? todoColor
                                          //         : pendingColor),
                                          color: todoColor,
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
                                        child: Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: new BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            // '${projects[index]!["background"]}'),
                                                            'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                                        fit: BoxFit.cover),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 22),
                                                  width: 32,
                                                  height: 32,
                                                  decoration: new BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            // '${projects[index]!["background"]}'),
                                                            'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                                        fit: BoxFit.cover),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 44),
                                                  width: 32,
                                                  height: 32,
                                                  decoration: new BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            // '${projects[index]!["background"]}'),
                                                            'https://scontent.fvca1-2.fna.fbcdn.net/v/t1.6435-9/190035792_1051142615293798_577040670142118185_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=1lB6NFX2w18AX-F1XX7&_nc_oc=AQkI-rgkX-fD7YGF3SqO8DG3EKUML4UyBDeaaKuTMD4VGaXQyiEjcX0Q3kUjtBKiIaM&tn=sOlpIfqnwCajxrnw&_nc_ht=scontent.fvca1-2.fna&oh=00_AT8lDJAVXKJ2EMEaFm9SlBJJkXuSfX2SqF9c56j1QOZXuA&oe=61DC63D7'),
                                                        fit: BoxFit.cover),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
                                                  // "${projects[index]!["deadline"]}",
                                                  projectSearchList[index]
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
                                                  // "${projects[index]!["quantityTask"]} task",
                                                  projectSearchList[index]
                                                      .quantityTask,
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
                                            (double.parse(
                                                projectSearchList[index]
                                                    .progress))),
                                        height: 9,
                                        decoration: BoxDecoration(
                                            color: todoColor,
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
                                      // "${projects[index]!["progress"]}%",
                                      projectSearchList[index].progress,
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
              SizedBox(height: 32)
            ],
          ),
        ),
      ],
    ));
  }
}
