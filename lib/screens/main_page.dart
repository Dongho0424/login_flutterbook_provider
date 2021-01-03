import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  MainPage({@required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(email),
            ),
            FlatButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text("logout"),
            ),
          ],
        ),
      ),
    );
  }
}
