import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import widgets
import 'package:grow_app/views/widget/dialogWidget.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';
import 'package:grow_app/constants/images.dart';
import 'package:grow_app/constants/icons.dart';
import 'package:grow_app/constants/others.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import others
import 'package:meta/meta.dart';

class taskModelScreen extends StatefulWidget {
  String uid;

  taskModelScreen(Required required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _taskModelScreenState createState() => _taskModelScreenState(uid);
}

class _taskModelScreenState extends State<taskModelScreen> {
  // final String? uid = controllers.currentUserId;

  String? uid = "";

  _taskModelScreenState(uid);

  FirebaseAuth auth = FirebaseAuth.instance;

  var taskcollections = FirebaseFirestore.instance.collection('users');
  late String task;

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid;
    print('The current uid is $uid');
  }

  void showdialog(bool isUpdate, DocumentSnapshot? ds) {
    GlobalKey<FormState> formkey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: isUpdate ? Text("Update Todo") : Text("Add Todo"),
            content: Form(
              key: formkey,
              autovalidate: true,
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Task",
                ),
                validator: (_val) {
                  if (_val!.isEmpty) {
                    return "Can't Be Empty";
                  } else {
                    return null;
                  }
                },
                onChanged: (_val) {
                  task = _val;
                },
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.purple,
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    formkey.currentState!.save();
                    if (isUpdate) {
                      taskcollections
                          .doc(uid)
                          .collection('task')
                          // .doc(ds.documentID)
                          .doc(ds?.id)
                          .update({
                        'task': task,
                        'time': DateTime.now(),
                      });
                    } else {
                      //  insert
                      taskcollections.doc(uid).collection('task').add({
                        'task': task,
                        'time': DateTime.now(),
                      });
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontFamily: "tepeno",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print(controllers.currentUserId);
          print(uid);
          // print(idd);
          showdialog(false, null);
        },
        // onPressed: () => null,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          "Tasks",
          style: TextStyle(
            fontFamily: "tepeno",
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            // onPressed: () => signOutUser().then((value) {
            //   Navigator.of(context).pushAndRemoveUntil(
            //       MaterialPageRoute(builder: (context) => authWrapper()),
            //       (Route<dynamic> route) => false);
            // }),
            onPressed: () => logoutDialog(context),
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (context) => authWrapper()),
            //     (Route<dynamic> route) => false);
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: taskcollections
            .doc(uid)
            .collection('task')
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      ds['task'],
                      style: TextStyle(
                        fontFamily: "tepeno",
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    onLongPress: () {
                      print(uid);
                      // delete
                      taskcollections
                          .doc(uid)
                          .collection('task')
                          // .doc(ds.documentID)
                          .doc(ds.id)
                          .delete();
                    },
                    onTap: () {
                      // == Update
                      showdialog(true, ds);
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return CircularProgressIndicator();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
