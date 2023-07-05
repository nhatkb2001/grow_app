import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import views
import 'package:grow_app/views/wrapper/onboardingWrapper.dart';
import 'package:grow_app/views/wrapper/authenticationWrapper.dart';

//import firebase
import 'package:firebase_core/firebase_core.dart';

//import provider - state management
import 'package:provider/provider.dart';

//import others
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

int initScreen = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize Firebase
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = (preferences.getInt('initScreen') ?? 0);
  await preferences.setInt('initScreen', 1);
  runApp(GrowApp());
}

class GrowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Grow',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          // const Locale('vn', 'VN'), // VietNam
        ],
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          primarySwatch: Colors.grey,
          cardColor: Colors.white70,
          accentColor: Colors.white,
        ),
        initialRoute:
            initScreen == 0 || initScreen == null ? 'onboarding' : 'auth',
        routes: {
          'onboarding': (context) => onboardingWrapper(),
          'auth': (context) => authenticationWrapper(),
        },
    );
  }
}


// // Test Firebase Firestore

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(
//     home: MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   TextEditingController sampledata1 = new TextEditingController();
//   TextEditingController sampledata2 = new TextEditingController();

//   final Stream<QuerySnapshot> users =
//       FirebaseFirestore.instance.collection('users').snapshots();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("firebase_demo"),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(40.0),
//         child: Center(
//           child: Column(
//             children: [
//               Container(
//                   height: 250,
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: users,
//                     builder: (
//                       BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot,
//                     ) {
//                       if (snapshot.hasError) {
//                         return Text('Something went wrong.');
//                       }
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Text('Loading');
//                       }

//                       final data = snapshot.requireData;

//                       return ListView.builder(
//                           itemCount: data.size,
//                           itemBuilder: (context, index) {
//                             return Text(
//                                 'My name is ${data.docs[index]['name']}and I am ${data.docs[index]['age']}');
//                           });
//                     },
//                   )),
//               TextFormField(
//                 controller: sampledata1,
//                 decoration: InputDecoration(hintText: "sample data 1"),
//               ),
//               SizedBox(height: 10.0),
//               TextFormField(
//                 controller: sampledata2,
//                 decoration: InputDecoration(hintText: "sample data 2"),
//               ),
//               SizedBox(height: 10.0),
//               FlatButton(
//                 onPressed: () {
//                   Map<String, dynamic> data = {
//                     "field1": sampledata1.text,
//                     "field2": sampledata2.text
//                   };
//                   FirebaseFirestore.instance.collection("text").add(data);
//                 },
//                 child: Text("Submit"),
//                 color: Colors.blueAccent,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
