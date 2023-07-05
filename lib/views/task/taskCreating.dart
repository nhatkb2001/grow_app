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
import 'package:grow_app/views/project/projectCenter.dart';
import 'package:grow_app/views/project/userSearching.dart';
import 'package:grow_app/views/task/assignTasks.dart';

//import widgets
import 'package:grow_app/views/widget/dialogWidget.dart';

//import views
import 'package:grow_app/views/project/projectManagement.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow_app/views/widget/snackBarWidget.dart';
import 'package:intl/intl.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';

class taskCreatingScreen extends StatefulWidget {
  String uid;
  String projectId;

  taskCreatingScreen(Required required,
      {Key? key, required this.uid, required this.projectId})
      : super(key: key);

  @override
  _taskCreatingScreenState createState() =>
      _taskCreatingScreenState(uid, projectId);
}

class _taskCreatingScreenState extends State<taskCreatingScreen> {
  // final String? uid = controllers.currentUserId;

  String uid = "";
  String projectId = "";

  int selected = 0;

  _taskCreatingScreenState(uid, this.projectId);

  FirebaseAuth auth = FirebaseAuth.instance;

  bool? haveDeadline = true;

  String newDeadline = "";

  String name = '';
  String description = "";
  String deadline = '';
  String background = '';
  String email = '';
  String newTaskId = "";

  late DateTime selectDate = DateTime.now();

  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> descriptionFormKey = GlobalKey<FormState>();

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
  List assigned = [];
  List<UserModel> userList = [];
  List<UserModel> userListChoice = [];

  late UserModel users = UserModel(
      avatar: '',
      dob: '',
      email: '',
      name: '',
      messagesList: [],
      job: '',
      phonenumber: '',
      projectsList: [],
      tasksList: [],
      userId: '');
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
              showSnackBar(context, "The asignee was took part in your project",
                  'error');
            }
          }
        });
        print("userListChoice");
        print(userListChoice);
      });
      setState(() {});
    });
  }

  Future createTask(String newTaskId) async {
    FirebaseFirestore.instance
        .collection("tasks")
        .add({
          'name': name,
          'description': description,
          'deadline': newDeadline,
          'owner': uid,
          'projectId': projectId,
          'progress': "0",
          'status': "pending",
          'assigned': FieldValue.arrayUnion(assigned)
        })
        .then(
          (value) => FirebaseFirestore.instance
              .collection("tasks")
              .doc(value.id)
              .update({
            'taskId': newTaskId = value.id,
          }),
        )
        .whenComplete(() => FirebaseFirestore.instance
            .collection("users")
            .get()
            .then((value) => value.docs.forEach((element) {
                  if (assigned.contains(element.data()['userId'] as String)) {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(element.id)
                        .update({
                      'tasksList': FieldValue.arrayUnion([newTaskId]),
                    });
                  }
                }))
            .whenComplete(
              () => FirebaseFirestore.instance
                  .collection("projects")
                  .doc(projectId)
                  .update({
                'tasksListId': FieldValue.arrayUnion([newTaskId]),
                'quantityTask': (double.parse(project.quantityTask) + 1)
                    .toStringAsFixed(0)
                    .toString()
              }),
            ));
  }

  var taskcollections = FirebaseFirestore.instance.collection('users');

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    print('The current uid is $uid');
    getProjectsDetail();
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
                        if (userListChoice.length == 0) {
                          showSnackBar(
                              context, " Please add assignee!", 'success');
                        } else {
                          createTask(newTaskId);
                          Navigator.pop(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         projectCenterScreen(required, uid: uid),
                          //   ),
                          // ).then((value) {});
                        }
                      },
                      child: Text(
                        "Create",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: purpleMain,
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
                          "Create New Task",
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
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Task Name",
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
                                          onChanged: (val) {
                                            name = val;
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter your task name",
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
                                          onChanged: (val) {
                                            description = val;
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                "Enter your description for task",
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
                                              newDeadline =
                                                  "${DateFormat('yMMMMd').format(selectDate)}";
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
                                            newDeadline = "";
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
                        children: [
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
                                        top: 24,
                                        left: 20,
                                        right: 20,
                                        bottom: 24),
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
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8))
                                                      : BorderRadius.all(
                                                          Radius.circular(0)),
                                                  border: (index <=
                                                          userListChoice
                                                                  .length -
                                                              1)
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
                                                      decoration:
                                                          new BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                // '${projects[index]!["background"]}'),
                                                                userListChoice[
                                                                        index]
                                                                    .avatar),
                                                            fit: BoxFit.cover),
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 16),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              userListChoice[
                                                                      index]
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 8,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color:
                                                                      greyDark,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ))),
                                                      ],
                                                    ),
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
                                                        assignTasksScreen(
                                                            required,
                                                            uid: uid,
                                                            projectId:
                                                                projectId,
                                                            email: email),
                                                  ),
                                                ).then((value) {
                                                  email = value;
                                                  getUserAssigned();
                                                }),
                                                child: AnimatedContainer(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    height: 48,
                                                    width: 280,
                                                    decoration: BoxDecoration(
                                                      color: purpleMain,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(width: 21),
                                                        Container(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Icon(
                                                                Iconsax.add,
                                                                size: 20,
                                                                color: white)),
                                                        SizedBox(width: 21),
                                                        Text(
                                                          "New Assignee",
                                                          style: TextStyle(
                                                            color: white,
                                                            fontFamily:
                                                                'Poppins',
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
                        ],
                      ),
                      SizedBox(height: 24),
                    ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
