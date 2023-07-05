import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:grow_app/views/project/projectManagement.dart';
import 'package:grow_app/views/profile/changingPassword.dart';
import 'package:grow_app/views/profile/profileCenter.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow_app/views/widget/snackBarWidget.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';

class loginDetailScreen extends StatefulWidget {
  String uid;

  loginDetailScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  loginDetailScreenState createState() => loginDetailScreenState(uid);
}

class loginDetailScreenState extends State<loginDetailScreen>
    with InputValidationMixin {
  // final String? uid = controllers.currentUserId;

  String uid = "";
  String? providerId = "";

  // String reName = '';
  // String date = '';
  // String rePhone = "";
  // String reJob = "";

  late DateTime selectDate = DateTime.now();

  late UserModel user = UserModel(
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
  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .listen((value) {
      setState(() {
        user = UserModel.fromDocument(value.docs.first.data());
        usernameController.text = user.name;
        jobController.text = user.job;
        phonenumberController.text = user.phonenumber;
        selectDate = DateFormat('yMMMMd').parse(user.dob);
      });
    });
  }

  Future updateUserDetail() async {
    FirebaseFirestore.instance.collection("users").doc(uid).update({
      'name': usernameController.text,
      'phonenumber': phonenumberController.text,
      'job': jobController.text,
      'dob': (DateFormat('yMMMMd').format(selectDate)).toString(),
    });
  }

  loginDetailScreenState(uid);

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');

  TextEditingController usernameController = TextEditingController();
  GlobalKey<FormState> usernameFormKey = GlobalKey<FormState>();
  TextEditingController jobController = TextEditingController();
  GlobalKey<FormState> jobFormKey = GlobalKey<FormState>();
  TextEditingController phonenumberController = TextEditingController();
  GlobalKey<FormState> phonenumberFormKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    providerId = user?.providerData[0].providerId.toString();
    print(providerId);
    // dynamic providerData = user?.providerData;
    // print(providerData);
    print('The current uid is $uid');
    getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundBasic), fit: BoxFit.cover),
            ),
          ),
          Container(
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
                        if (usernameFormKey.currentState!.validate() &&
                            phonenumberFormKey.currentState!.validate() &&
                            jobFormKey.currentState!.validate()) {
                          updateUserDetail();
                          showSnackBar(context,
                              'Successfully changed the profile!', 'success');
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
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 28, right: 28),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Login Details",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 24.0,
                              color: black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 24),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "User Name",
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
                                key: usernameFormKey,
                                child: Container(
                                  width: 319,
                                  height: 48,
                                  padding: EdgeInsets.only(left: 24, right: 24),
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
                                      controller: usernameController,
                                      keyboardType: TextInputType.text,
                                      // onChanged: (val) {
                                      //   reName = val;
                                      // },
                                      // initialValue: user.name,
                                      //validator
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
                                        // hintText: user.name,
                                        hintText: "Enter your user name",
                                        hintStyle: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: greyDark,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(height: 24),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Date of Birth",
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
                                  onTap: () async {
                                    String category = "dob";
                                    DateTime? dt = await datePickerDialog(
                                        context, selectDate, category);
                                    if (dt != null) {
                                      selectDate = dt;
                                      setState(() {
                                        selectDate != selectDate;
                                      });
                                    }
                                    print(selectDate);
                                  },
                                  child: AnimatedContainer(
                                      alignment: Alignment.center,
                                      duration: Duration(milliseconds: 300),
                                      height: 48,
                                      width: 180,
                                      decoration: BoxDecoration(
                                        color: purpleLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 12),
                                          Container(
                                              padding: EdgeInsets.zero,
                                              alignment: Alignment.center,
                                              child: Icon(Iconsax.calendar_1,
                                                  size: 16, color: black)),
                                          SizedBox(width: 8),
                                          Text(
                                            // "12 November, 2021",
                                            "${DateFormat('yMMMMd').format(selectDate)}",

                                            style: TextStyle(
                                              color: black,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(width: 4)
                                        ],
                                      )),
                                ))
                          ]),
                      SizedBox(height: 24),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Your Job",
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
                                key: jobFormKey,
                                child: Container(
                                  width: 319,
                                  height: 48,
                                  padding: EdgeInsets.only(left: 24, right: 24),
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
                                      controller: jobController,
                                      keyboardType: TextInputType.text,
                                      // onChanged: (val) {
                                      //   reJob = val;
                                      // },
                                      //validator
                                      validator: (job) {
                                        if (isJobValid(job.toString())) {
                                          return null;
                                        } else {
                                          return '';
                                        }
                                      },
                                      // initialValue: user.job,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                        ),
                                        border: InputBorder.none,
                                        // hintText: user.job,
                                        hintText: "Enter your job",
                                        hintStyle: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: greyDark,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(height: 24),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Phone Number",
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
                                key: phonenumberFormKey,
                                child: Container(
                                  width: 319,
                                  height: 48,
                                  padding: EdgeInsets.only(left: 24, right: 24),
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
                                      controller: phonenumberController,
                                      keyboardType: TextInputType.phone,
                                      // onChanged: (val) {
                                      //   rePhone = val;
                                      // },
                                      //validator
                                      validator: (phonenumber) {
                                        if (isPhonenumberValid(
                                            phonenumber.toString())) {
                                          return null;
                                        } else {
                                          return '';
                                        }
                                      },
                                      // initialValue: user.phonenumber,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                        ),
                                        border: InputBorder.none,
                                        // hintText: user.phonenumber,
                                        hintText: "Enter your phone number",
                                        hintStyle: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: greyDark,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(height: 24),
                      (providerId == "password")
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Container(
                                    child: Text(
                                      "Password",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 20.0,
                                          color: black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  changingPasswordScreen(
                                                      required,
                                                      uid: uid),
                                            ),
                                          );
                                        },
                                        child: AnimatedContainer(
                                            alignment: Alignment.center,
                                            duration:
                                                Duration(milliseconds: 300),
                                            height: 56,
                                            width: 256,
                                            decoration: BoxDecoration(
                                              color: purpleMain,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      black.withOpacity(0.25),
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.zero,
                                                    alignment: Alignment.center,
                                                    child: Icon(Iconsax.edit_2,
                                                        size: 24,
                                                        color: white)),
                                                SizedBox(width: 12),
                                                Text(
                                                  "Change Password",
                                                  style: TextStyle(
                                                    color: white,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(width: 4)
                                              ],
                                            )),
                                      ))
                                ])
                          : Column()
                    ]),
              )
            ]),
          )
        ],
      ),
    );
  }
}

//Create validation
mixin InputValidationMixin {
  // bool isEmailValid(String email) {
  //   RegExp regex = new RegExp(
  //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //   return regex.hasMatch(email);
  // }

  bool isNameValid(String name) => name.length >= 3;

  bool isJobValid(String name) => name.length >= 1;

  // bool isPasswordValid(String password) => password.length >= 6;

  bool isPhonenumberValid(String phoneNumber) {
    RegExp regex = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regex.hasMatch(phoneNumber);
  }
}
