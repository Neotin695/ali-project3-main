import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/Screens/BottomNavigationBar.dart';
import 'package:project2/Screens/LoginScreen.dart';
import 'package:project2/Screens/SignUpScreen.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return  const Bar();
          }
          else {
            return const SignupScreen();
          }
        }),
      ),
    );
  }
}
