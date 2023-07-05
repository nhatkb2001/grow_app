import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import views
import 'package:grow_app/views/authentication/signUp.dart';
import 'package:grow_app/views/authentication/recoveryPassword.dart';

//import controllers
import 'package:grow_app/controllers/authController.dart';

//import firebase
import 'package:firebase_auth/firebase_auth.dart';

// //import provider - state management
// import 'package:provider/provider.dart';

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

class signinScreen extends StatefulWidget {
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<signinScreen> {
  bool isHiddenPassword = true;

  // final formKey = new GlobalKey<FormState>();

  // final emailController = TextEditingController();

  // final passwordController = TextEditingController();

  // // final authService = Provider.of<AuthService>(context);

  // late String email, password;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late String email, password, userid;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // void login() {
  //   if (formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     signin(email, password, context).then((value) {
  //       if (value != null) {
  //         Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => TasksPage(required, uid: value.uid),
  //             ));
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                image: AssetImage(backgroundOnboarding), fit: BoxFit.cover),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Image(image: AssetImage(atSalySayhi)),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 39, right: 39),
                    width: width,
                    decoration: BoxDecoration(
                      color: Color(0xffF5F5F5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 26),
                          child: Text('Sign In to' + '\n' + 'Govern Together!',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: black,
                                fontSize: title28,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        SizedBox(height: 13),
                        Form(
                          key: formKey,
                          child: Container(
                            width: 300,
                            height: 50,
                            margin: EdgeInsets.symmetric(vertical: 13),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: purpleLight),
                            alignment: Alignment.topLeft,
                            child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: [AutofillHints.email],
                                // validator: (email) => email != null &&
                                //         !EmailValidator.validate(email)
                                //     ? 'Enter a valid email'
                                //     : null,
                                // validator: MultiValidator([
                                //   RequiredValidator(
                                //       errorText: "This Field Is Required"),
                                //   EmailValidator(
                                //       errorText: "Invalid Email Address"),
                                // ]),
                                // onChanged: (val) {
                                //   email = val;
                                // },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: content14,
                                    color: greyDark,
                                  ),
                                  hintText: "Enter your email",
                                )),
                          ),
                        ),
                        Form(
                          // key: formKey,
                          child: Container(
                            width: 300,
                            height: 50,
                            margin: EdgeInsets.symmetric(vertical: 13),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: purpleLight),
                            alignment: Alignment.topLeft,
                            child: TextFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: [AutofillHints.password],
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
                                obscureText: isHiddenPassword,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                      onTap: _togglePasswordView,
                                      child: isHiddenPassword
                                          ? Stack(
                                              alignment: Alignment.centerRight,
                                              children: [
                                                  SvgPicture.asset(
                                                      eyeVisibility,
                                                      color: greyDark,
                                                      height: 24,
                                                      width: 24)
                                                ])
                                          : Stack(
                                              alignment: Alignment.centerRight,
                                              children: [
                                                  SvgPicture.asset(
                                                      eyeInvisibility,
                                                      color: greyDark,
                                                      height: 24,
                                                      width: 24)
                                                ])),
                                  border: InputBorder.none,
                                  hintText: "Enter your password",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: content14,
                                      color: greyDark),
                                )),
                          ),
                        ),
                        Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(top: 4),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => recoveryScreen()),
                                );
                              },
                              child: Text('Recovery password',
                                  style: TextStyle(
                                    color: greyDark,
                                    fontSize: suggestion12,
                                    fontWeight: FontWeight.w600,
                                  )),
                            )),
                        Stack(children: [
                          Container(
                            padding: EdgeInsets.only(top: 28, right: 16),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  height: 54,
                                  width: 260,
                                  decoration: BoxDecoration(
                                    color: purpleDark.withOpacity(0.3),
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
                                        blurRadius: 60,
                                        offset: Offset(10, 10),
                                      ),
                                    ],
                                  ),
                                ),
                                Blur(
                                  blur: 10,
                                  blurColor: whiteLight.withOpacity(0.3),
                                  child: Container(
                                    height: 64,
                                    width: 278,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 24),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () => loginUser(emailController.text, passwordController.text, context),
                                // onTap: () => login(),
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
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: white,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: textButton),
                                  ),
                                ),
                              )
                          )
                        ]),
                        SizedBox(height: 16),
                        Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "or continue with",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: greyLight,
                                  fontSize: suggestion12
                              ),
                            )
                        ),
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
                                  "Don't have an account? ",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: suggestion12),
                                )),
                            Container(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => signupScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Register here!",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: purpleDark,
                                        fontWeight: FontWeight.w600,
                                        fontSize: suggestion12),
                                  )),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Create function
  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}
