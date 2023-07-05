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
import 'package:grow_app/views/project/userSearching.dart';

//import widgets
import 'package:grow_app/views/widget/dialogWidget.dart';

//import views
import 'package:grow_app/views/project/projectManagement.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow_app/views/widget/snackBarWidget.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class projectEditingScreen extends StatefulWidget {
  String uid;
  String projectId;

  projectEditingScreen(Required required,
      {Key? key, required this.uid, required this.projectId})
      : super(key: key);

  @override
  _projectEditingScreenState createState() =>
      _projectEditingScreenState(uid, projectId);
}

class _projectEditingScreenState extends State<projectEditingScreen>
    with InputValidationMixin {
  // final String? uid = controllers.currentUserId;

  String uid = "";
  String email = "";
  String projectId = "";
  String reName = '';
  String reDescription = "";
  String reDeadline = '';
  List assigned = [];

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

  List<UserModel> userList = [];
  List<UserModel> userListChoice = [];

  int selected = 0;

  bool? haveDeadline = true;

  late DateTime selectDate = DateTime.now();

  _projectEditingScreenState(uid, this.projectId);

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> descriptionFormKey = GlobalKey<FormState>();

  var taskcollections = FirebaseFirestore.instance.collection('users');
  Future getAssigned() async {
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
                userListChoice.add(UserModel.fromDocument(element.data()));
              }
            });
            print("userListChoice");
            print(userListChoice.length);
          });
          setState(() {});
        });
      });
    });
  }

  List<Task> taskAllList = [];
  List taskAllId = [];
  Future getTaskAllList() async {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .snapshots()
        .listen((value) {
      taskAllId = value.data()!["tasksListId"];
      FirebaseFirestore.instance
          .collection("tasks")
          .snapshots()
          .listen((value) {
        setState(() {
          value.docs.forEach((element) {
            var check = taskAllList
                .where((element) => taskAllId.contains(element.taskId));
            if (check.isEmpty) {
              if (taskAllId.contains(element.data()['taskId'] as String)) {
                taskAllList.add(Task.fromDocument(element.data()));
              }
            }
          });
          print(taskAllList.length);
        });
      });
      setState(() {});
    });
  }

  Future getUserAssigned() async {
    FirebaseFirestore.instance.collection("users").get().then((value) {
      setState(() {
        value.docs.forEach((element) {
          if (email.contains(element.data()['email'] as String)) {
            var check =
                userListChoice.where((element) => element.email == email);
            assigned.add(element.data()['userId'] as String);
            if (check.isEmpty) {
              userListChoice.add(UserModel.fromDocument(element.data()));
              showSnackBar(context, "The asignee has been add in your project",
                  'success');
            } else {
              showSnackBar(context,
                  "The asignee has been took part in your project", 'error');
            }
          }
        });
        print("userListChoice");
        print(userListChoice);
      });
      setState(() {});
    });
  }

  Future getProjectsDetail() async {
    FirebaseFirestore.instance
        .collection("projects")
        .where("projectId", isEqualTo: projectId)
        .snapshots()
        .listen((value) {
      setState(() {
        project = Project.fromDocument(value.docs.first.data());
        nameController.text = project.name;
        descriptionController.text = project.description;
        selectDate = DateFormat('yMMMMd').parse(project.deadline);
      });
      print(project.name);
    });
  }

  Future updateProjectsDetail() async {
    FirebaseFirestore.instance
        .collection("projects")
        .where("projectId", isEqualTo: projectId)
        .snapshots()
        .listen((value) {
      setState(() {
        project = Project.fromDocument(value.docs.first.data());
        FirebaseFirestore.instance
            .collection("projects")
            .doc(project.projectId)
            .update({
          'name': nameController.text,
          'description': descriptionController.text,
          'deadline': (DateFormat('yMMMMd').format(selectDate)).toString(),
          'assigned': FieldValue.arrayUnion(assigned),
        }).whenComplete(() => FirebaseFirestore.instance
                .collection("users")
                .get()
                .then((value) => value.docs.forEach((element) {
                      if (assigned
                          .contains(element.data()['userId'] as String)) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(element.id)
                            .update({
                          'projectsList':
                              FieldValue.arrayUnion([project.projectId]),
                        });
                      }
                    })));
      });
      print(project.name);
    });
  }

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    print('The current uid is $uid');
    getProjectsDetail();
    getAssigned();
    getTaskAllList();
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
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, size: 28, color: black),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(bottom: 6, right: 28),
                  child: GestureDetector(
                      onTap: () {
                        if (nameFormKey.currentState!.validate() &&
                            descriptionFormKey.currentState!.validate()) {
                          updateProjectsDetail();
                          showSnackBar(
                              context,
                              'Successfully changed the project detail!',
                              'success');
                          Navigator.pop(context);
                        } else {
                          showSnackBar(
                              context,
                              "Information can not be blank or incorrect!",
                              'error');
                        }
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
              SizedBox(height: 18),
              Container(
                padding: EdgeInsets.only(left: 28, right: 28),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Project Name",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 20.0,
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Form(
                                    key: nameFormKey,
                                    child: Container(
                                      width: 319,
                                      height: 48,
                                      padding:
                                          EdgeInsets.only(left: 24, right: 24),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: purpleLight),
                                      alignment: Alignment.topCenter,
                                      child: TextFormField(
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              color: black,
                                              fontWeight: FontWeight.w400),
                                          controller: nameController,
                                          keyboardType: TextInputType.text,
                                          // onChanged: (val) {
                                          //   reName = val;
                                          // },
                                          validator: (name) {
                                            if (isNameValid(name.toString())) {
                                              return null;
                                            } else {
                                              return '';
                                            }
                                          },
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              color: Colors.transparent,
                                              fontSize: 0,
                                              height: 0,
                                            ),
                                            border: InputBorder.none,
                                            hintText: project.name,
                                            hintStyle: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: Color(0xFF666666),
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ),
                                  ),
                                ),
                              ]),
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
                                    "Description",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 20.0,
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Form(
                                    key: descriptionFormKey,
                                    child: Container(
                                      width: 319,
                                      height: 48,
                                      padding:
                                          EdgeInsets.only(left: 24, right: 24),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: purpleLight),
                                      alignment: Alignment.topCenter,
                                      child: TextFormField(
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              color: black,
                                              fontWeight: FontWeight.w400),
                                          controller: descriptionController,
                                          keyboardType: TextInputType.text,
                                          // onChanged: (val) {
                                          //   reDescription = val;
                                          // },
                                          validator: (name) {
                                            if (isDescriptionValid(
                                                name.toString())) {
                                              return null;
                                            } else {
                                              return '';
                                            }
                                          },
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              color: Colors.transparent,
                                              fontSize: 0,
                                              height: 0,
                                            ),
                                            border: InputBorder.none,
                                            hintText: project.description,
                                            hintStyle: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: Color(0xFF666666),
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ),
                                  ),
                                ),
                              ]),
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
                                    "Deadline",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 20.0,
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () async {
                                          String category = "task";
                                          DateTime? dt = await datePickerDialog(
                                              context, selectDate, category);
                                          if (dt != null) {
                                            selectDate = dt;
                                            setState(() {
                                              haveDeadline = true;
                                              haveDeadline != haveDeadline;
                                              selectDate != selectDate;
                                              // reDeadline =
                                              //     "${DateFormat('yMMMMd').format(selectDate)}";
                                            });
                                          }
                                          print(haveDeadline);
                                          print(selectDate);
                                        },
                                        child: AnimatedContainer(
                                            alignment: Alignment.center,
                                            duration:
                                                Duration(milliseconds: 300),
                                            height: 48,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color: (haveDeadline == true)
                                                  ? purpleLight
                                                  : white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 12),
                                                Container(
                                                    padding: EdgeInsets.zero,
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                        Iconsax.calendar_1,
                                                        size: 16,
                                                        color: greyDark)),
                                                SizedBox(width: 8),
                                                Text(
                                                  // "12 November, 2021",
                                                  "${DateFormat('yMMMMd').format(selectDate)}",
                                                  // "${selectDate.day} ${selectDate.month}, ${selectDate.year}",
                                                  style: TextStyle(
                                                    color: greyDark,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(width: 4)
                                              ],
                                            )),
                                      )),
                                  Spacer(),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            haveDeadline = false;
                                            haveDeadline != haveDeadline;
                                            reDeadline = "";
                                          });
                                          print(haveDeadline);
                                          print(selectDate);
                                        },
                                        child: AnimatedContainer(
                                            alignment: Alignment.center,
                                            duration:
                                                Duration(milliseconds: 300),
                                            height: 48,
                                            width: 130,
                                            decoration: BoxDecoration(
                                              color: (haveDeadline == true)
                                                  ? white
                                                  : purpleLight,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 8),
                                                Container(
                                                    padding: EdgeInsets.zero,
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                        (haveDeadline == true)
                                                            ? Iconsax.cd
                                                            : Iconsax
                                                                .tick_circle,
                                                        size: 16,
                                                        color: greyDark)),
                                                SizedBox(width: 8),
                                                Text(
                                                  "No Deadline",
                                                  style: TextStyle(
                                                    color: greyDark,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                              ],
                                            )),
                                      )),
                                ])
                              ]),
                        ],
                      ),
                      SizedBox(height: 24),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Assignee",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 20.0,
                                    color: black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 12),
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
                                        itemCount: userListChoice.length,
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
                                                            userListChoice[
                                                                    index]
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
                                                          userListChoice[index]
                                                              .name,
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
                                                            userListChoice[
                                                                    index]
                                                                .job,
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
                                                (index == 0)
                                                    ? Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  leaderStar)),
                                                        ),
                                                      )
                                                    : Container(),
                                                SizedBox(width: 16)
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    userSearchingScreen(
                                                        required,
                                                        email: email),
                                              ),
                                            ).then((value) {
                                              email = value;
                                              getUserAssigned();
                                            }),
                                            child: AnimatedContainer(
                                                alignment: Alignment.centerLeft,
                                                duration:
                                                    Duration(milliseconds: 300),
                                                height: 48,
                                                width: 280,
                                                decoration: BoxDecoration(
                                                  color: purpleMain,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft: Radius
                                                              .circular(8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 21),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(Iconsax.add,
                                                            size: 20,
                                                            color: white)),
                                                    SizedBox(width: 21),
                                                    Text(
                                                      "New Assignee",
                                                      style: TextStyle(
                                                        color: white,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ))
                                    ]))
                          ]),
                      SizedBox(height: 24),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Remove",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 20.0,
                                    color: black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () => removeProjectDialog(
                                      context,
                                      project.projectId,
                                      uid,
                                      assigned,
                                      taskAllId),
                                  child: AnimatedContainer(
                                      alignment: Alignment.center,
                                      duration: Duration(milliseconds: 300),
                                      height: 48,
                                      width: 180,
                                      decoration: BoxDecoration(
                                        color: red,
                                        borderRadius: BorderRadius.circular(8),
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
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Remove this project",
                                          style: TextStyle(
                                            color: white,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )),
                                ))
                          ]),
                      SizedBox(height: 56),
                    ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

mixin InputValidationMixin {
  // bool isEmailValid(String email) {
  //   RegExp regex = new RegExp(
  //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //   return regex.hasMatch(email);
  // }

  bool isNameValid(String name) => name.length >= 1;

  bool isDescriptionValid(String name) => name.length >= 1;

  // bool isPasswordValid(String password) => password.length >= 6;

  // bool isPhonenumberValid(String phoneNumber) {
  //   RegExp regex = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  //   return regex.hasMatch(phoneNumber);
  // }
}
