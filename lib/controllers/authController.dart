import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import views
import 'package:grow_app/views/authentication/checkinEmail.dart';
import 'package:grow_app/views/wrapper/navigationBar.dart';

//import widgets
import 'package:grow_app/views/widget/snackBarWidget.dart';

//import firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import login method
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

//import others
import 'dart:math';

FirebaseAuth auth = FirebaseAuth.instance;
// int randomNumber = Random().nextInt(9000) + 1000;

Future registerUser(String email, String password, String name,
    String phoneNumber, context) async {
  try {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      final User? user = auth.currentUser;
      final uid = user?.uid;
      // print("Your current id is $uid");
      //store user data to firestore

      FirebaseFirestore.instance.collection("users").doc(uid).set({
        'name': name,
        'email': email,
        "userId": uid,
        'phonenumber': phoneNumber,
        'dob': '',
        'job': 'Freelancer',
        'avatar': "https://i.imgur.com/YtZkAbe.jpg",
        'tasksList': FieldValue.arrayUnion([]),
        'messagesList': FieldValue.arrayUnion([]),
        'projectsList': FieldValue.arrayUnion([]),
      }).then((signedInUser) => {
            print("successfully registered!"),
          });
      loginUser(email, password, context);
    });
  } on FirebaseAuthException catch (e) {
    print(e.code);
    switch (e.code) {
      case "operation-not-allowed":
        showSnackBar(context, "Anonymous accounts are not enabled!", 'error');
        break;
      case "weak-password":
        showSnackBar(context, "Your password is too weak!", 'error');
        break;
      case "invalid-email":
        showSnackBar(context, "Your email is invalid, please check!", 'error');
        break;
      case "email-already-in-use":
        showSnackBar(context, "Email is used on different account!", 'error');
        break;
      case "invalid-credential":
        showSnackBar(context, "Your email is invalid, please check!", 'error');
        break;

      default:
        showSnackBar(context, "An undefined Error happened.", 'error');
    }
  }
}

Future<void> changePassword(currentPassword, newPassword, context) async {
  final user = FirebaseAuth.instance.currentUser!;
  try {
    try {
      var authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: (user.email).toString(),
          password: currentPassword,
        ),
      );
      user.updatePassword(newPassword).then((_) {
        showSnackBar(context, 'Successfully changed password!', 'success');
        Navigator.pop(context);
      }).catchError((error) {
        showSnackBar(context, 'Your current password is wrong!', 'error');
      });
      return null;
    } on FirebaseAuthException {
      showSnackBar(context, 'Your current password is wrong!', 'error');
    }
  } on FirebaseAuthException {
    showSnackBar(context, 'Your current password is wrong!', 'error');
  }
}

Future resetPasswordUser(String email, context) async {
  try {
    await auth.sendPasswordResetEmail(email: email).then((value) => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => checkinEmailScreen(),
            ),
          )
        });
  } on FirebaseAuthException catch (e) {
    print(e.code);
    switch (e.code) {
      case "invalid-email":
        showSnackBar(context, "Your email is invalid, please check!", 'error');
        break;
      case "user-not-found":
        showSnackBar(
            context, "Your email is not found, please check!", 'error');
        break;

      default:
        showSnackBar(context, "An undefined Error happened.", 'error');
    }
  }
}

Future loginUser(String email, String password, context) async {
  try {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print("successfully login!");
      final User? user = auth.currentUser;
      final uid = user?.uid;
      // print("Your current id is $uid");
      if (uid != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => navigationBar(required, uid: uid)));
      }
    });
  } on FirebaseAuthException catch (e) {
    print(e.code);
    switch (e.code) {
      case "user-not-found":
        showSnackBar(
            context, "Your email is not found, please check!", 'error');
        break;
      case "wrong-password":
        showSnackBar(context, "Your password is wrong, please check!", 'error');
        break;
      case "invalid-email":
        showSnackBar(context, "Your email is invalid, please check!", 'error');
        break;
      case "user-disabled":
        showSnackBar(context, "The user account has been disabled!", 'error');
        break;
      case "too-many-requests":
        showSnackBar(
            context, "There was too many attempts to sign in!", 'error');
        break;
      case "operation-not-allowed":
        showSnackBar(context, "The user account are not enabled!", 'error');
        break;
      // // Preventing user from entering email already provided by other login method
      // case "account-exists-with-different-credential":
      //   showErrorSnackBar(context, "This account exists with a different sign in provider!");
      //   break;

      default:
        showSnackBar(context, "An undefined Error happened.", 'error');
    }
  }
}

Future signOutUser() async {
  await FirebaseAuth.instance
      .signOut()
      .then((value) => {print("successfully signout!")});
  await FacebookAuth.instance.logOut();
  final User? user = await auth.currentUser;
  final uid = user?.uid;
  // print("Your current id is $uid");
}

Future googleSignIn(context) async {
  try {
    final googleMethod = await GoogleSignIn().signIn();
    final auth = await googleMethod!.authentication;
    final cred = GoogleAuthProvider.credential(
        idToken: auth.idToken, accessToken: auth.accessToken);
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(cred)
        .whenComplete(() {});

    final User? googleUser = userCredential.user;
    final uid = googleUser?.uid;
    final GoogleSignInAccount? userData = googleMethod;

    print("Your current id is $uid");
    print("Your current email is " + userData!.email.toString());
    print("Your current photoUrl is " + userData.photoUrl.toString());
    print("Your current displayName is " + userData.displayName.toString());
    // print("Your current id is " + userData.id.toString());

    if (userCredential.additionalUserInfo!.isNewUser) {
      FirebaseFirestore.instance.collection("users").doc(uid).set({
        'name': userData.displayName,
        'email': userData.email,
        "userId": uid,
        'phonenumber': '',
        'dob': '',
        'avatar': userData.photoUrl,
        'job': '',
        'tasksList': FieldValue.arrayUnion([]),
        'messagesList': FieldValue.arrayUnion([]),
        'projectsList': FieldValue.arrayUnion([]),
      }).then((signedInUser) => {
            print("successfully registered!"),
          });
    }
    if (uid != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => navigationBar(required, uid: uid)));
    }
  } catch (e) {
    print("error");
  }
}

Future facebookSignIn(context) async {
  try {
    final facebookMethod = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);
    if (facebookMethod.status == LoginStatus.success) {
      final cred =
          FacebookAuthProvider.credential(facebookMethod.accessToken!.token);
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(cred)
          .whenComplete(() {});

      final User? facebookUser = userCredential.user;
      final uid = facebookUser?.uid;
      final userData = await FacebookAuth.instance.getUserData();

      print("Your current id is $uid");
      print("Your current userData is $userData");
      print("Your current email is " + userData['email'].toString());
      print("Your current photoUrl is " +
          userData['picture']['data']['url'].toString());
      print("Your current displayName is " + userData['name'].toString());
      // print("Your current id is " + userData['id'].toString());

      if (userCredential.additionalUserInfo!.isNewUser) {
        FirebaseFirestore.instance.collection("users").doc(uid).set({
          'name': userData['name'],
          'email': userData['email'],
          "userId": uid,
          'phonenumber': '',
          'dob': '',
          'job': '',
          'avatar': userData['picture']['data']['url'],
          'tasksList': FieldValue.arrayUnion([]),
          'messagesList': FieldValue.arrayUnion([]),
          'projectsList': FieldValue.arrayUnion([]),
        }).then((signedInUser) => {
              print("successfully registered!"),
            });
      }
      if (uid != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => navigationBar(required, uid: uid)));
      }
    }
  } catch (e) {
    print("error");
  }
}

// Future<UserCredential> signInWithFacebook() async {
//   final LoginResult result =
//       await FacebookAuth.instance.login(permissions: ['email']);

//   if (result.status == LoginStatus.success) {
//     final userData = await FacebookAuth.instance.getUserData();
//   } else {
//     print(result.message);
//   }

//   final OAuthCredential facebookAuthCredential =
//       FacebookAuthProvider.credential(result.accessToken!.token);

//   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
// }

// Future facebookSignInn(context) async {
//   try {
//     final facebookMethod = await FacebookAuth.instance.login();
//     // final facebookuser = await FacebookAuth.instance.getUserData();

//     final cred =
//         FacebookAuthProvider.credential(facebookMethod.accessToken!.token);
//     final UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithCredential(cred);

//     User? facebookUser = userCredential.user;
//     final uid = facebookUser?.uid;

//     print("Your current id is $uid");
//     print("Your current email is " + user!.email.toString());
//     print("Your current photoUrl is " + user!.photoUrl.toString());
//     print("Your current displayName is " + user!.displayName.toString());
//     // print("Your current id is " + user!.id.toString());

//     if (userCredential.additionalUserInfo!.isNewUser) {
//       FirebaseFirestore.instance.collection("Users").doc(uid).set({
//         'name': user!.displayName,
//         'email': user!.email,
//         'phonenumber': null,
//       }).then((signedInUser) => {
//             print("successfully registered!"),
//           });
//     }
//     if (uid != null) {
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => TasksPage(required, uid: uid)));
//     }
//   } catch (e) {
//     print("error");
//   }
// }

// Future<UserCredential> signInWithGoogle() async {
//   // Trigger the authentication flow
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication? googleAuth =
//       await googleUser?.authentication;

//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   );

//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }

// Future<bool> signOutUser() async {
//   User? user = await auth.currentUser;
//   print(user?.providerData[1].providerId);
//   if (user?.providerData[1].providerId == 'google.com') {
//     // await gooleSignIn.disconnect();
//   }
//   await auth.signOut();
//   return Future.value(true);
// }

// FirebaseAuth auth = FirebaseAuth.instance;
// final gooleSignIn = GoogleSignIn();

// // a simple sialog to be visible everytime some error occurs
// showErrDialog(BuildContext context, String err) {
//   // to hide the keyboard, if it is still p
//   FocusScope.of(context).requestFocus(new FocusNode());
//   return showDialog(
//     builder: (context) => AlertDialog(
//       title: Text("Error"),
//       content: Text(err),
//       actions: <Widget>[
//         OutlineButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text("Ok"),
//         ),
//       ],
//     ), context: context,
//   );
// }

// // many unhandled google error exist
// // will push them soon
// Future<bool> googleSignIn() async {
//   GoogleSignInAccount? googleSignInAccount = await gooleSignIn.signIn();

//   if (googleSignInAccount != null) {
//     GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;

//     AuthCredential credential = GoogleAuthProvider.credential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken);

//     UserCredential result = await auth.signInWithCredential(credential);

//     User user = await auth.currentUser!;
//     print(user.uid);

//     return Future.value(true);
//   }
//   return Future.value(false);
// }

// // instead of returning true or false
// // returning user to directly access UserID
// Future<User> signin(
//     String email, String password, BuildContext context) async {
//   try {
//     UserCredential result =
//         await auth.signInWithEmailAndPassword(email: email, password: email);
//     User user = result.user!;
//     // return Future.value(true);
//     return Future.value(user);
//   } on FirebaseAuthException catch (e) {
//     // simply passing error code as a message
//     print(e.code);
//     switch (e.code) {
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_WRONG_PASSWORD':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_NOT_FOUND':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_DISABLED':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_TOO_MANY_REQUESTS':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_OPERATION_NOT_ALLOWED':
//         showErrDialog(context, e.code);
//         break;
//     }
//     // since we are not actually continuing after displaying errors
//     // the false value will not be returned
//     // hence we don't have to check the valur returned in from the signin function
//     // whenever we call it anywhere
//     return Future.value(null);
//   }
// }

// // change to Future<FirebaseUser> for returning a user
// Future<User> signUp(
//     String email, String password, BuildContext context) async {
//   try {
//     UserCredential result = await auth.createUserWithEmailAndPassword(
//         email: email, password: email);
//     User user = result.user!;
//     return Future.value(user);
//     // return Future.value(true);
//   } on FirebaseAuthException catch (error) {
//     switch (error.code) {
//       case 'ERROR_EMAIL_ALREADY_IN_USE':
//         showErrDialog(context, "Email Already Exists");
//         break;
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, "Invalid Email Address");
//         break;
//       case 'ERROR_WEAK_PASSWORD':
//         showErrDialog(context, "Please Choose a stronger password");
//         break;
//     }
//     return Future.value(null);
//   }
// }

// Future<bool> signOutUser() async {
//   User user = await auth.currentUser!;
//   print(user.providerData[1].providerId);
//   if (user.providerData[1].providerId == 'google.com') {
//     await gooleSignIn.disconnect();
//   }
//   await auth.signOut();
//   return Future.value(true);
// }

// AUTH SERVICE

// // import models
// import 'package:grow_app/models/userModel.dart';

// // import firebase
// import 'package:firebase_auth/firebase_auth.dart' as auth;

// class AuthService {
//   final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

//   User? _userFromFirebase(auth.User? user) {
//     if (user == null) {
//       return null;
//     }
//     return User(user.uid, user.email);
//   }

//   Stream<User?>? get user {
//     return _firebaseAuth.authStateChanges().map(_userFromFirebase);
//   }

//   Future<User?> signInWithEmailandPassword(
//     String email,
//     String password,
//   ) async {
//     final credential = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email, password: password);
//     return _userFromFirebase(credential.user);
//   }

//   Future<User?> createWithEmailandPassword(
//     String email,
//     String password,
//   ) async {
//     final credential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     return _userFromFirebase(credential.user);
//   }

//   Future<void> signOut() async {
//     return await _firebaseAuth.signOut();
//   }
// }
