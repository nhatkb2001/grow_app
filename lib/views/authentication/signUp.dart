import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import views
import 'package:grow_app/views/authentication/signIn.dart';
import 'package:grow_app/views/profile/termCondition.dart';

//import widgets
import 'package:grow_app/views/widget/snackBarWidget.dart';

//import controllers
import 'package:grow_app/controllers/authController.dart';

//import firebase
import 'package:firebase_auth/firebase_auth.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';

//import others
import 'package:flutter/services.dart';
import 'package:blur/blur.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:custom_check_box/custom_check_box.dart';

class signupScreen extends StatefulWidget with InputValidationMixin {
  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signupScreen> with InputValidationMixin {
  bool isHiddenPassword = true;
  bool checkBoxValue = false;

  final GlobalKey<FormState> _formEmailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formPasswordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formPhoneNumberKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Color notiColorEmail = red;
  Color notiColorName = red;
  Color notiColorPhoneNumber = red;
  Color notiColorPassword = red;

  // late String email, password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgroundOnboarding),
                      fit: BoxFit.cover),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  SizedBox(height: 48),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 52, left: 37),
                        child: Text(
                          "Sign Up to " + '\n' + "Work with Us!",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: title28,
                            fontWeight: FontWeight.w600,
                            color: white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Image.asset(atPhoneExciting, scale: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Container(
                      child: Column(children: [
                    Container(
                        padding: EdgeInsets.only(left: 36, right: 36),
                        child: Column(
                          children: [
                            Form(
                                autovalidate: true,
                                key: _formEmailKey,
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofillHints: [AutofillHints.email],
                                      style: TextStyle(color: greyDark),
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                            child: Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      Icons.error_outline,
                                                      size: 24,
                                                      color: notiColorEmail),
                                                  tooltip:
                                                      'Your email must be valid',
                                                ),
                                              )
                                            ])),
                                        contentPadding:
                                            EdgeInsets.only(left: 20, right: 8),
                                        hintStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: content14,
                                          color: greyDark,
                                        ),
                                        hintText: "Enter your email",
                                        filled: true,
                                        fillColor: purpleLight,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                          // foreground: Paint()..shader = redGradient
                                        ),
                                      ),
                                      //validator
                                      validator: (email) {
                                        if (isEmailValid(email.toString())) {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              notiColorEmail = green;
                                            });
                                          });
                                          return null;
                                        } else {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              notiColorEmail = red;
                                            });
                                          });
                                          return '';
                                        }
                                      },
                                    ),
                                  ],
                                )),
                            SizedBox(height: 20),
                            Form(
                                autovalidate: true,
                                key: _formNameKey,
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      controller: nameController,
                                      keyboardType: TextInputType.name,
                                      autofillHints: [AutofillHints.name],
                                      style: TextStyle(color: greyDark),
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                            child: Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      Icons.error_outline,
                                                      size: 24,
                                                      color: notiColorName),
                                                  tooltip:
                                                      'Your name must have more than 3 characters',
                                                ),
                                              )
                                            ])),
                                        contentPadding:
                                            EdgeInsets.only(left: 20, right: 8),
                                        hintStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: content14,
                                          color: greyDark,
                                        ),
                                        hintText: "Enter your name",
                                        filled: true,
                                        fillColor: purpleLight,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                          // foreground: Paint()..shader = redGradient
                                        ),
                                      ),
                                      //validator
                                      validator: (name) {
                                        if (isNameValid(name.toString())) {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              notiColorName = green;
                                            });
                                          });
                                          return null;
                                        } else {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              notiColorName = red;
                                            });
                                          });
                                          return '';
                                        }
                                      },
                                    ),
                                  ],
                                )),
                            // Form(
                            //   autovalidate: true,
                            //   key: _formNameKey,
                            //   child: TextFormField(
                            //     controller: nameController,
                            //     keyboardType: TextInputType.name,
                            //     autofillHints: [AutofillHints.name],
                            //     style: TextStyle(color: greyDark),
                            //     decoration: InputDecoration(
                            //       contentPadding:
                            //           EdgeInsets.only(left: 20, right: 20),
                            //       hintStyle: TextStyle(
                            //         fontFamily: 'Poppins',
                            //         fontSize: content14,
                            //         color: greyDark,
                            //       ),
                            //       hintText: "Enter your name",
                            //       filled: true,
                            //       fillColor: purpleLight,
                            //       border: OutlineInputBorder(
                            //         borderSide: BorderSide.none,
                            //         borderRadius: BorderRadius.circular(10.0),
                            //       ),
                            //       errorStyle: TextStyle(
                            //           foreground: Paint()
                            //             ..shader = redGradient),
                            //     ),
                            //     //validator
                            //     // validator: MultiValidator([
                            //     //   RequiredValidator(
                            //     //       errorText: "Please enter your name"),
                            //     //   MinLengthValidator(3,
                            //     //       errorText: "Your name must be at least 3 digits length"),
                            //     // ]),
                            //     // onChanged: (String? value) {
                            //     //   name = value;
                            //     // },
                            //     validator: (name) {
                            //       if (isNameValid(name.toString()))
                            //         return null;
                            //       else
                            //         return 'Enter a valid name';
                            //     },
                            //   ),
                            // ),
                            SizedBox(height: 20),
                            Form(
                                autovalidate: true,
                                key: _formPhoneNumberKey,
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      controller: phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      autofillHints: [
                                        AutofillHints.telephoneNumber
                                      ],
                                      style: TextStyle(color: greyDark),
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                            child: Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      Icons.error_outline,
                                                      size: 24,
                                                      color:
                                                          notiColorPhoneNumber),
                                                  tooltip:
                                                      'Your phone numbers must be valid',
                                                ),
                                              )
                                            ])),
                                        contentPadding:
                                            EdgeInsets.only(left: 20, right: 8),
                                        hintStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: content14,
                                          color: greyDark,
                                        ),
                                        hintText: "Enter your phone numbers",
                                        filled: true,
                                        fillColor: purpleLight,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                          // foreground: Paint()..shader = redGradient
                                        ),
                                      ),
                                      //validator
                                      validator: (phoneNumber) {
                                        if (isPhoneNumberValid(
                                            phoneNumber.toString())) {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              notiColorPhoneNumber = green;
                                            });
                                          });
                                          return null;
                                        } else {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              notiColorPhoneNumber = red;
                                            });
                                          });
                                          return '';
                                        }
                                      },
                                    ),
                                  ],
                                )),
                            // Form(
                            //   autovalidate: true,
                            //   key: _formPhoneNumberKey,
                            //   child: TextFormField(
                            //     controller: phoneNumberController,
                            //     keyboardType: TextInputType.phone,
                            //     autofillHints: [AutofillHints.telephoneNumber],
                            //     style: TextStyle(color: greyDark),
                            //     decoration: InputDecoration(
                            //       contentPadding:
                            //           EdgeInsets.only(left: 20, right: 20),
                            //       hintStyle: TextStyle(
                            //         fontFamily: 'Poppins',
                            //         fontSize: content14,
                            //         color: greyDark,
                            //       ),
                            //       hintText: "Enter your phone numbers",
                            //       filled: true,
                            //       fillColor: purpleLight,
                            //       border: OutlineInputBorder(
                            //         borderSide: BorderSide.none,
                            //         borderRadius: BorderRadius.circular(10.0),
                            //       ),
                            //       errorStyle: TextStyle(
                            //           foreground: Paint()
                            //             ..shader = redGradient),
                            //     ),
                            //     //validator
                            //     // validator: MultiValidator([
                            //     //   RequiredValidator(
                            //     //       errorText: "Please enter your phone numbers"),
                            //     //   MinLengthValidator(10,
                            //     //       errorText:
                            //     //           "Your phone numbers is not valid"),
                            //     // ]),
                            //     // onChanged: (String? value) {
                            //     //   phoneNumber = value;
                            //     // },
                            //     validator: (phoneNumber) {
                            //       if (isPhoneNumberValid(
                            //           phoneNumber.toString()))
                            //         return null;
                            //       else
                            //         return 'Enter a valid phone numbers';
                            //     },
                            //   ),
                            // ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  width: 248,
                                  child: Form(
                                    autovalidate: true,
                                    key: _formPasswordKey,
                                    child: TextFormField(
                                      controller: passwordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      autofillHints: [AutofillHints.password],
                                      obscureText: isHiddenPassword,
                                      style: TextStyle(color: greyDark),
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                            // onTap: _togglePasswordView,
                                            child: Container(
                                          width: 56,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // isHiddenPassword
                                              //     ? Stack(
                                              //         alignment: Alignment
                                              //             .centerRight,
                                              //         children: [
                                              //             Container(
                                              //                 padding: EdgeInsets
                                              //                     .only(
                                              //                         right:
                                              //                             8),
                                              //                 child: SvgPicture.asset(
                                              //                     eyeVisibility,
                                              //                     color:
                                              //                         greyDark,
                                              //                     height:
                                              //                         24,
                                              //                     width:
                                              //                         24))
                                              //           ])
                                              //     : Stack(
                                              //         alignment: Alignment
                                              //             .centerRight,
                                              //         children: [
                                              //             Container(
                                              //                 padding: EdgeInsets
                                              //                     .only(
                                              //                         right:
                                              //                             8),
                                              //                 child: SvgPicture.asset(
                                              //                     eyeInvisibility,
                                              //                     color:
                                              //                         greyDark,
                                              //                     height:
                                              //                         24,
                                              //                     width:
                                              //                         24))
                                              //           ]),
                                              Stack(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 8),
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                            Icons.error_outline,
                                                            size: 24,
                                                            color:
                                                                notiColorPassword),
                                                        tooltip:
                                                            'Your password must have more than 6 characters',
                                                      ),
                                                    )
                                                  ])
                                            ],
                                          ),
                                        )),
                                        contentPadding:
                                            EdgeInsets.only(left: 20, right: 8),
                                        hintStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: content14,
                                          color: greyDark,
                                        ),
                                        hintText: "Enter your password",
                                        filled: true,
                                        fillColor: purpleLight,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                          // foreground: Paint()..shader = redGradient
                                        ),
                                      ),
                                      //validator
                                      validator: (password) {
                                        if (isPasswordValid(
                                            password.toString())) {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              notiColorPassword = green;
                                            });
                                          });
                                          return null;
                                        } else {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              notiColorPassword = red;
                                            });
                                          });
                                          return '';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                new Spacer(),
                                InkWell(
                                    onTap: _togglePasswordView,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                          color: isHiddenPassword
                                              ? purpleLight
                                              : purpleDark,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: isHiddenPassword
                                          ? Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                  Container(
                                                      child: SvgPicture.asset(
                                                          eyeInvisibility,
                                                          color: purpleDark,
                                                          height: 24,
                                                          width: 24))
                                                ])
                                          : Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                  Container(
                                                      child: SvgPicture.asset(
                                                          eyeVisibility,
                                                          color: white,
                                                          height: 24,
                                                          width: 24))
                                                ]),
                                    ))
                              ],
                            ),
                          ],
                        )),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 23.0),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: new CustomCheckBox(
                              value: checkBoxValue,
                              shouldShowBorder: true,
                              borderColor: white,
                              checkedFillColor: white,
                              checkedIconColor: black,
                              borderRadius: 4,
                              borderWidth: 1.5,
                              checkBoxSize: 16,
                              // onChanged: _activeCheckAccept,
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxValue = newValue;
                                });
                              }),
                        ),
                        Container(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => conditionScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Accept terms & Conditions",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: suggestion12),
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          if (_formEmailKey.currentState!.validate() &&
                              _formNameKey.currentState!.validate() &&
                              _formPhoneNumberKey.currentState!.validate() &&
                              _formPasswordKey.currentState!.validate()) {
                            if (checkBoxValue == true) {
                              _formEmailKey.currentState!.save();
                              _formNameKey.currentState!.save();
                              _formPhoneNumberKey.currentState!.save();
                              _formPasswordKey.currentState!.save();
                              registerUser(
                                  emailController.text,
                                  passwordController.text,
                                  nameController.text,
                                  phoneNumberController.text,
                                  context);
                            } else {
                              showSnackBar(context,
                                  'Please accept terms & conditions!', 'error');
                            }
                          } else {
                            showSnackBar(
                                context, 'Please confirm validation!', 'error');
                          }
                        },
                        child: AnimatedContainer(
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 300),
                            height: 54,
                            width: 260,
                            decoration: BoxDecoration(
                              color: purpleDark,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: white.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 64,
                                  offset: Offset(
                                      15, 15), // changes position of shadow
                                ),
                                BoxShadow(
                                  color: white.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 20,
                                  offset: Offset(
                                      8, 8), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: textButton),
                            )),
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "or sign up with",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: greyLight,
                              fontSize: suggestion12),
                        )),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => googleSignIn(context),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(googleLogoIcon)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => facebookSignIn(context),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(facebookLogoIcon)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Already have an account? ",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: suggestion12),
                            )),
                        Container(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => signinScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login here!",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: purpleDark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: suggestion12),
                              )),
                        )
                      ],
                    ),
                  ]))
                ]))));
  }

  //Create function
  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}

//Create validation
mixin InputValidationMixin {
  bool isEmailValid(String email) {
    RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
  }

  bool isNameValid(String name) => name.length >= 3;

  bool isPasswordValid(String password) => password.length >= 6;

  bool isPhoneNumberValid(String phoneNumber) {
    RegExp regex = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regex.hasMatch(phoneNumber);
  }
}
