import 'package:flutter/material.dart';
import 'package:project2/Screens/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project2/Screens/SignUpScreen.dart';
import 'package:project2/Screens/Splash.dart';
import 'package:project2/Screens/page1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      // home: Auth(),
      routes: {
        '/': (context) => const SplashScreen(),
        'signupScreen': (context) => const SignupScreen(),
        'loginScreen': (context) => const LoginScreen(),
        'homeScreen': (context) => HomeScreen(),
      },
    );
  }
}
