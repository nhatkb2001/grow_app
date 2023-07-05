import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';

//import controllers
import 'package:grow_app/controllers/authController.dart';

//import views
import 'package:grow_app/views/profile/loginDetail.dart';
import 'package:grow_app/views/profile/profileCenter.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow_app/views/widget/snackBarWidget.dart';

//import others
import 'package:meta/meta.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';

class changingPasswordScreen extends StatefulWidget {
  String uid;

  changingPasswordScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  changingPasswordScreenState createState() => changingPasswordScreenState(uid);
}

class changingPasswordScreenState extends State<changingPasswordScreen>
    with InputValidationMixin {
  // final String? uid = controllers.currentUserId;

  String uid = "";

  changingPasswordScreenState(uid);

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');

  bool isHiddenCurrentPassword = true;
  bool isHiddenNewPassword = true;
  bool isHiddenConfirmPassword = true;

  TextEditingController currentController = TextEditingController();
  GlobalKey<FormState> currentFormKey = GlobalKey<FormState>();
  TextEditingController newController = TextEditingController();
  GlobalKey<FormState> newFormKey = GlobalKey<FormState>();
  TextEditingController confirmController = TextEditingController();
  GlobalKey<FormState> confirmFormKey = GlobalKey<FormState>();

  // changePassword() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   String currentPassword = currentController.text;
  //   String newPassword = newController.text;
  //   try {
  //     AuthCredential cred = EmailAuthProvider.credential(email: (user!.email).toString(), password: currentPassword);
  //     user.reauthenticateWithCredential(cred).catchError((error) {
  //       print("Password can't be changed" + error.toString());
  //     }).then((value) {
  //       user.updatePassword(newPassword).then((_) {
  //         showSnackBar(context, 'Successfully changed password!', 'success');
  //         Navigator.pop(context);
  //       }).catchError((error) {
  //       print("Password can't be changed" + error.toString());
  //       });
  //     }).catchError((error) {
  //       print("Password can't be changed" + error.toString());
  //     });
  //   } on FirebaseAuthException {
  //     showSnackBar(context, 'Your current password! is wrong', 'error');
  //   }
  //   // user.reauthenticateWithCredential(cred).then((value) {
  //   //   user.updatePassword(newController.text).then((_) {
  //   //     showSnackBar(context, 'Successfully changed password!', 'success')
  //   //     Navigator.pop(context);
  //   //   }) on FirebaseAuthException {
  //   //     showSnackBar(context, 'Your current password! is wrong', 'error');
  //   //   });
  //   // }).catchError((error) {
  //   //   showSnackBar(context, 'Your current password! is wrong', 'error');
  //   // });
  // }

  // .catchError((error) {
  //       showSnackBar(context, 'Your current password! is wrong', 'error');
  //     });
  // .catchError((error) {
  //     showSnackBar(context, 'Your current password! is wrong', 'error');
  //   });

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    print('The current uid is $uid');
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
                // Spacer(),
                // Container(
                //   padding: EdgeInsets.only(bottom: 6, right: 28),
                //   child: GestureDetector(
                //       onTap: () {
                //         Navigator.pop(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) =>
                //                 loginDetailScreen(required, uid: uid),
                //           ),
                //         );
                //       },
                //       child: Text(
                //         "Save",
                //         style: TextStyle(
                //             fontFamily: 'Poppins',
                //             color: purpleMain,
                //             fontWeight: FontWeight.w600,
                //             fontSize: 16),
                //       )),
                // )
              ]),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 28, right: 28),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Change Password",
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
                                "Current Password",
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
                                key: currentFormKey,
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
                                      controller: currentController,
                                      obscureText: isHiddenCurrentPassword,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      autofillHints: [AutofillHints.password],
                                      validator: (Currentpassword) {
                                        if (isCurrentPasswordValid(
                                            Currentpassword.toString())) {
                                          return null;
                                        } else {
                                          return '';
                                        }
                                      },
                                      // validator: (value) => value.isEmpty
                                      //     ? 'Password is required'
                                      //     : null,
                                      // validator: MultiValidator([
                                      //   RequiredValidator(
                                      //       errorText: "Password Is Required"),
                                      //   MinLengthValidator(6,
                                      //       errorText:
                                      //           "Minimum 6 Characters Required"),
                                      // ]),
                                      // onChanged: (val) {
                                      //   password = val;
                                      // },
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                        ),
                                        suffixIcon: InkWell(
                                            onTap: _toggleCurrentPasswordView,
                                            child: isHiddenCurrentPassword
                                                ? Stack(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    children: [
                                                        SvgPicture.asset(
                                                            eyeVisibility,
                                                            color: greyDark,
                                                            height: 24,
                                                            width: 24)
                                                      ])
                                                : Stack(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    children: [
                                                        SvgPicture.asset(
                                                            eyeInvisibility,
                                                            color: greyDark,
                                                            height: 24,
                                                            width: 24)
                                                      ])),
                                        border: InputBorder.none,
                                        hintText: "Enter your current password",
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
                      SizedBox(height: 24),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "New Password",
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
                                key: newFormKey,
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
                                      controller: newController,
                                      obscureText: isHiddenNewPassword,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      autofillHints: [AutofillHints.password],
                                      validator: (Newpassword) {
                                        if (isNewPasswordValid(
                                            Newpassword.toString())) {
                                          return null;
                                        } else {
                                          return '';
                                        }
                                      },
                                      // validator: (value) => value.isEmpty
                                      //     ? 'Password is required'
                                      //     : null,
                                      // validator: MultiValidator([
                                      //   RequiredValidator(
                                      //       errorText: "Password Is Required"),
                                      //   MinLengthValidator(6,
                                      //       errorText:
                                      //           "Minimum 6 Characters Required"),
                                      // ]),
                                      // onChanged: (val) {
                                      //   password = val;
                                      // },
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                        ),
                                        suffixIcon: InkWell(
                                            onTap: _toggleNewPasswordView,
                                            child: isHiddenNewPassword
                                                ? Stack(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    children: [
                                                        SvgPicture.asset(
                                                            eyeVisibility,
                                                            color: greyDark,
                                                            height: 24,
                                                            width: 24)
                                                      ])
                                                : Stack(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    children: [
                                                        SvgPicture.asset(
                                                            eyeInvisibility,
                                                            color: greyDark,
                                                            height: 24,
                                                            width: 24)
                                                      ])),
                                        border: InputBorder.none,
                                        hintText: "Enter your new password",
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
                      SizedBox(height: 24),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Confirm New Password",
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
                                key: confirmFormKey,
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
                                      controller: confirmController,
                                      obscureText: isHiddenConfirmPassword,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      autofillHints: [AutofillHints.password],
                                      validator: (Currentpassword) {
                                        if (isConfirmPasswordValid(
                                            Currentpassword.toString())) {
                                          return null;
                                        } else {
                                          return '';
                                        }
                                      },
                                      // validator: (value) => value.isEmpty
                                      //     ? 'Password is required'
                                      //     : null,
                                      // validator: MultiValidator([
                                      //   RequiredValidator(
                                      //       errorText: "Password Is Required"),
                                      //   MinLengthValidator(6,
                                      //       errorText:
                                      //           "Minimum 6 Characters Required"),
                                      // ]),
                                      // onChanged: (val) {
                                      //   password = val;
                                      // },
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                        ),
                                        suffixIcon: InkWell(
                                            onTap: _toggleConfirmPasswordView,
                                            child: isHiddenConfirmPassword
                                                ? Stack(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    children: [
                                                        SvgPicture.asset(
                                                            eyeVisibility,
                                                            color: greyDark,
                                                            height: 24,
                                                            width: 24)
                                                      ])
                                                : Stack(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    children: [
                                                        SvgPicture.asset(
                                                            eyeInvisibility,
                                                            color: greyDark,
                                                            height: 24,
                                                            width: 24)
                                                      ])),
                                        border: InputBorder.none,
                                        hintText: "Confirm your new password",
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
                      SizedBox(height: 64),
                      Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              if (currentFormKey.currentState!.validate() &&
                                  newFormKey.currentState!.validate() &&
                                  confirmFormKey.currentState!.validate()) {
                                if (newController.text ==
                                    confirmController.text) {
                                  changePassword(currentController.text,
                                      newController.text, context);
                                } else {
                                  showSnackBar(
                                      context,
                                      "Confirm password does not match!",
                                      'error');
                                }
                              } else {
                                showSnackBar(
                                    context,
                                    "Information can not be blank or incorrect!",
                                    'error');
                              }
                            },
                            child: AnimatedContainer(
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 300),
                                height: 48,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: purpleMain,
                                  borderRadius: BorderRadius.circular(15),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Confirm",
                                      style: TextStyle(
                                        color: white,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )),
                          ))
                    ]),
              )
            ]),
          )
        ],
      ),
    );
  }

  //Create function
  void _toggleCurrentPasswordView() {
    setState(() {
      isHiddenCurrentPassword = !isHiddenCurrentPassword;
    });
  }

  void _toggleNewPasswordView() {
    setState(() {
      isHiddenNewPassword = !isHiddenNewPassword;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      isHiddenConfirmPassword = !isHiddenConfirmPassword;
    });
  }
}

mixin InputValidationMixin {
  // bool isEmailValid(String email) {
  //   RegExp regex = new RegExp(
  //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //   return regex.hasMatch(email);
  // }
  bool isCurrentPasswordValid(String Currentpassword) =>
      Currentpassword.length >= 6;
  bool isNewPasswordValid(String Newpassword) => Newpassword.length >= 6;
  bool isConfirmPasswordValid(String Confirmpassword) =>
      Confirmpassword.length >= 6;
}
