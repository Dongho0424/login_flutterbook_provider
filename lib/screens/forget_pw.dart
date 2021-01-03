import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPW extends StatefulWidget {
  @override
  _ForgetPWState createState() => _ForgetPWState();
}

class _ForgetPWState extends State<ForgetPW> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext inContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: "Email",
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (String inValue) {
                if (inValue.isEmpty) {
                  return "Please input correct Email";
                }
                return null;
              },
            ),
            Builder(
              builder: (inContext) => FlatButton(
                onPressed: () async {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);

                  SnackBar snackBar = SnackBar(content: Text("Check your email for password reset"), duration: Duration(seconds: 2),);
                  Scaffold.of(inContext).showSnackBar(snackBar);
                },
                child: Text("Reset Password!"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
