import 'dart:developer';
import 'dart:io';

import 'package:chatx/helper/dialogs.dart';
import 'package:chatx/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../../api/apis.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _handleGoogleBtnClick() {
    //For showing progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //For hiding progress bar
      Navigator.pop(context);
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)');
      return null;
    }
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
            child: SizedBox(
              width: 500,
              height: 550,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 2, 54, 138),
                            Color.fromARGB(255, 0, 29, 74),
                            Color.fromARGB(255, 0, 18, 41),
                            Color.fromARGB(255, 0, 14, 36),
                          ]),
                      borderRadius: BorderRadius.circular(20)),
                  //width: 300,
                  //height: 500,
                  child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          'images/logo.png',
                          width: 125,
                          height: 125,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'ChatX',
                          style: TextStyle(
                            color: Colors.blue.shade200,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Stay connected with\nFriends & Familiy,\nAnytime & Anywhere',
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              elevation: 1,
                            ),
                            onPressed: () {
                              _handleGoogleBtnClick();
                            },
                            icon: Image.asset(
                              'images/google.png',
                              width: 15,
                              height: 15,
                            ),
                            label: RichText(
                                text: const TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    children: [
                                  TextSpan(text: 'Login with '),
                                  TextSpan(
                                      text: 'Google',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ])))
                      ]),
                ),
              ),
            ),
          ),
        ));
  }
}
