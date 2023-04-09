import 'dart:developer';

import 'package:chatx/api/apis.dart';
import 'package:chatx/screens/home_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      // Exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(255, 2, 26, 63),
          systemNavigationBarColor: Colors.transparent));

      if (APIs.auth.currentUser != null) {
        log('\nuser: ${APIs.auth.currentUser}');
        // Navigate to Home Screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        // Navigate to login Screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 0, 0, 12),
              Color.fromARGB(255, 0, 0, 35),
              Color.fromARGB(255, 6, 6, 59)
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo.png',
                ),
                const SizedBox(
                  height: 310,
                ),
                Text(
                  'ChatX- Chatting App',
                  style: TextStyle(
                    color: Colors.blue.shade500,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    letterSpacing: .5,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
