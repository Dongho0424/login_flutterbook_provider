import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_flutterbook_provider/JoinOrLoginModel.dart';
import 'package:login_flutterbook_provider/screens/login.dart';
import 'package:path_provider/path_provider.dart';
import 'notes/Notes.dart';
import 'screens/login.dart';
import 'screens/main_page.dart';
import 'package:provider/provider.dart';
import 'utils.dart' as utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Directory docsDir = await getApplicationDocumentsDirectory();
  utils.docsDir = docsDir;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext inContext) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

// 처음 앱을 실행할 때 로고같은 것 보여주는 페이지
class Splash extends StatelessWidget {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return ChangeNotifierProvider<JoinOrLogin>(
            create: (_) => JoinOrLogin(),
            child: AuthPage(),
            // builder: (context, child){
            //   return AuthPage();
            // },
          );
        } else {
          // return MainPage(email: snapshot.data.email);
          return DonghoBook();
        }
      },
    );
  }
}

class DonghoBook extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[
    Tab(
      icon: Icon(Icons.date_range),
      text: "Appointments",
    ),
    Tab(
      icon: Icon(Icons.contacts),
      text: "Contacts",
    ),
    Tab(
      icon: Icon(Icons.note),
      text: "Notes",
    ),
    Tab(
      icon: Icon(Icons.assignment_turned_in),
      text: "Tasks",
    ),
  ];

  /// The build() method.
  ///
  /// @param  context The BuildContext for this widget.
  /// @return           A Widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Dongho"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.outbond),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
          body: TabBarView(children: [
            Test(),
            Test(),
            Notes(),
            Test(),
            // Contacts(),
            // Appointments(),
            // Tasks(),
          ]),
        ),
      ),
    );
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

