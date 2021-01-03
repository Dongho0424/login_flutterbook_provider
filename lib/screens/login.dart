import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_flutterbook_provider/screens/forget_pw.dart';
import 'file:///C:/Users/user/AndroidStudioProjects/login_flutterbook_provider/lib/screens/main_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../JoinOrLoginModel.dart';
import 'login_background.dart';

class AuthPage extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext inContext) {
    // 앱의 사이즈
    final Size size = MediaQuery.of(inContext).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(inContext).requestFocus(FocusNode()),
        child: Stack(
          children: [
            CustomPaint(
              size: size,
              painter: LoginBackground(
                  isJoin: Provider.of<JoinOrLogin>(inContext).isJoin),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _logoImage,
                Builder(
                  builder: (inContext) => Stack(
                    children: [
                      // InputForm(
                      //   size: size,
                      //   formKey: _formKey,
                      //   emailController: emailController,
                      //   passwordController: passwordController,
                      // ),
                      // AuthButton(
                      //   size: size,
                      //   formKey: _formKey,
                      //   emailController: emailController,
                      //   passwordController: passwordController,
                      // ),
                      _inputForm(inContext, size),
                      _authButton(inContext, size),
                    ],
                  ),
                ),
                Container(height: size.height * 0.09),
                Consumer<JoinOrLogin>(
                  builder: (inConsumerContext, joinOrLogin, child) {
                    return TextButton(
                      onPressed: () {
                        joinOrLogin.toggle();
                      },
                      child: joinOrLogin.isJoin
                          ? Text("Already have an Account? Login!")
                          : Text("Don't Have an Account? Create One!"),
                    );
                  },
                ),
                Container(height: size.height * 0.05),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _logoImage {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
        child: FittedBox(
          fit: BoxFit.contain,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/hi.gif"),
          ),
        ),
      ),
    );
  }

  Widget _inputForm(BuildContext inContext, Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        // margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 18, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    labelText: "Password",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String inValue) {
                    if (inValue.isEmpty) {
                      return "Please input correct Password";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),

                // Text(
                //   Provider.of<JoinOrLogin>(inContext).isJoin
                //       ? ""
                //       : "Forgot Password",
                //   style: TextStyle(color: Colors.black54),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      inContext,
                      MaterialPageRoute(
                        builder: (BuildContext inRouteContext) {
                          return ForgetPW();
                        },
                      ),
                    );
                  },
                  child: Provider.of<JoinOrLogin>(inContext).isJoin
                      ? Spacer()
                      : Text("Forgot Password"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _authButton(BuildContext inContext, Size size) {
    Color _color = Provider.of<JoinOrLogin>(inContext).isJoin
        ? Colors.red
        : Colors.blue[900];

    return Positioned(
      left: size.width * 0.15,
      right: size.width * 0.15,
      bottom: 0,
      child: SizedBox(
        height: 43,
        child: Consumer<JoinOrLogin>(
          builder: (inConsumerContext, joinOrLogin, child) => RaisedButton(
            child: Text(
              joinOrLogin.isJoin ? "Join" : "Login",
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            color: _color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              FocusScope.of(inContext).requestFocus(FocusNode());
              if (_formKey.currentState.validate()) {
                joinOrLogin.isJoin ? _register(inContext) : _login(inContext);
              }
            },
          ),
        ),
      ),
    );
  }

// 로그인
  void _login(BuildContext inContext) async {
    final UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
    final User user = result.user;

    if (user == null) {
      print("Where are you, user..");
      // final snackBar = SnackBar(content: Text("Please try again later"));
      Scaffold.of(inContext)
          .showSnackBar(SnackBar(content: Text("Please try again later")));
    } else {
      print("Hi user..");
      // final snackBar = SnackBar(content: Text("Successfully log in!"));
      Scaffold.of(inContext)
          .showSnackBar(SnackBar(content: Text("Successfully log in!")));
    }
  }

// 계정 생성
  void _register(BuildContext inContext) async {
    final UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
    final User user = result.user;

    if (user == null) {
      // final snackBar = SnackBar(content: Text("Please try again later"));
      Scaffold.of(inContext)
          .showSnackBar(SnackBar(content: Text("Please try again later")));
    } else {
      // final snackBar = SnackBar(
      //     content: Text("Successfully create an account!"));
      Scaffold.of(inContext).showSnackBar(
          SnackBar(content: Text("Successfully create an account!")));
    }
  }
}
//
// // 로그인
// void _login(BuildContext inContext, TextEditingController emailController,
//     TextEditingController passwordController) async {
//   final UserCredential result = await FirebaseAuth.instance
//       .signInWithEmailAndPassword(
//           email: emailController.text, password: passwordController.text);
//   final User user = result.user;
//
//   if (user == null) {
//     final snackBar = SnackBar(content: Text("Please try again later"));
//     Scaffold.of(inContext).showSnackBar(snackBar);
//   } else {
//     final snackBar = SnackBar(content: Text("Successfully log in!"));
//     Scaffold.of(inContext).showSnackBar(snackBar);
//   }
// }
//
// // 계정 생성
// void _register(BuildContext inContext, TextEditingController emailController,
//     TextEditingController passwordController) async {
//   final UserCredential result = await FirebaseAuth.instance
//       .createUserWithEmailAndPassword(
//           email: emailController.text, password: passwordController.text);
//   final User user = result.user;
//
//   if (user == null) {
//     final snackBar = SnackBar(content: Text("Please try again later"));
//     Scaffold.of(inContext).showSnackBar(snackBar);
//   } else {
//     final snackBar = SnackBar(content: Text("Successfully create an account!"));
//     Scaffold.of(inContext).showSnackBar(snackBar);
//   }
// }
//
// class InputForm extends StatelessWidget {
//   const InputForm({
//     Key key,
//     @required this.size,
//     @required GlobalKey<FormState> formKey,
//     @required this.emailController,
//     @required this.passwordController,
//   })  : _formKey = formKey,
//         super(key: key);
//
//   final Size size;
//   final GlobalKey<FormState> _formKey;
//   final TextEditingController emailController;
//   final TextEditingController passwordController;
//
//   @override
//   Widget build(BuildContext inContext) {
//     return Padding(
//       padding: EdgeInsets.all(size.width * 0.05),
//       child: Card(
//         // margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 10,
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(15, 15, 18, 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     icon: Icon(Icons.account_circle),
//                     labelText: "Email",
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (String inValue) {
//                     if (inValue.isEmpty) {
//                       return "Please input correct Email";
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   obscureText: true,
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     icon: Icon(Icons.vpn_key),
//                     labelText: "Password",
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (String inValue) {
//                     if (inValue.isEmpty) {
//                       return "Please input correct Password";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//
//                 Text(
//                   Provider.of<JoinOrLogin>(inContext).isJoin
//                       ? ""
//                       : "Forgot Password",
//                   style: TextStyle(color: Colors.black54),
//                 ),
//                 // GestureDetector(
//                 //   onTap: () {
//                 //     Navigator.push(
//                 //       inContext,
//                 //       MaterialPageRoute(
//                 //         builder: (BuildContext inRouteContext) {
//                 //           return ForgetPW();
//                 //         },
//                 //       ),
//                 //     );
//                 //   },
//                 //   child: Provider.of<JoinOrLogin>(inContext).isJoin
//                 //       ? Spacer()
//                 //       : Text("Forgot Password"),
//                 // )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AuthButton extends StatelessWidget {
//   AuthButton({
//     Key key,
//     @required this.size,
//     @required GlobalKey<FormState> formKey,
//     @required this.emailController,
//     @required this.passwordController,
//   })  : _formKey = formKey,
//         super(key: key);
//
//   TextEditingController emailController;
//   TextEditingController passwordController;
//   final Size size;
//   final GlobalKey<FormState> _formKey;
//
//   @override
//   Widget build(BuildContext inContext) {
//     Color _color = Provider.of<JoinOrLogin>(inContext).isJoin
//         ? Colors.red
//         : Colors.blue[900];
//
//     return Positioned(
//       left: size.width * 0.15,
//       right: size.width * 0.15,
//       bottom: 0,
//       child: SizedBox(
//         height: 43,
//         child: Consumer<JoinOrLogin>(
//           builder: (inConsumerContext, joinOrLogin, child) => RaisedButton(
//             child: Text(
//               joinOrLogin.isJoin ? "Join" : "Login",
//               style: TextStyle(fontSize: 17.0, color: Colors.white),
//             ),
//             color: _color,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             onPressed: () {
//               if (_formKey.currentState.validate()) {
//                 joinOrLogin.isJoin
//                     ? _register(
//                         inConsumerContext, emailController, passwordController)
//                     : _login(
//                         inConsumerContext, emailController, passwordController);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
