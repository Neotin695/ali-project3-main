import 'package:flutter/material.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:project2/Screens/Auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isInternetAvailable = true;

  @override
  void initState() {
    isInternetConnected().then((value) {
      setState(() {
        isInternetAvailable = value;
      });
    });
    super.initState();
  }

  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isInternetAvailable
          ? const Auth()
          : Lottie.asset('images/113265-no-internet-connection.json'),
    );
  }
}
