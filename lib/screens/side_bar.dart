import 'package:chatx/api/apis.dart';
import 'package:chatx/screens/About/about_screen.dart';
import 'package:chatx/screens/home_screen.dart';
import 'package:chatx/screens/profile_screen.dart';
import 'package:chatx/screens/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helper/dialogs.dart';
import 'auth/login_screen.dart';

class SideBarScreen extends StatelessWidget {
  const SideBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      width: 280,
      child: Drawer(
        backgroundColor: const Color.fromARGB(255, 2, 26, 63),
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'ChatX',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  //fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  fontSize: 30),
            ),

            const SizedBox(
              height: 30,
            ),

            //divider
            const Divider(
              color: Colors.lightBlue,
              endIndent: 25,
              indent: 25,
            ),

            //home button
            _OptionItem(
                icon: const Icon(
                  Icons.home_rounded,
                  color: Colors.lightBlue,
                ),
                name: 'Home',
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()));
                })),

            //divider
            const Divider(
              color: Colors.lightBlue,
              endIndent: 25,
              indent: 25,
            ),

            //profile button
            _OptionItem(
                icon: const Icon(
                  CupertinoIcons.person_crop_circle_fill,
                  color: Colors.lightBlue,
                ),
                name: 'Your Profile',
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UserProfileScreen(me: APIs.me)));
                })),

            //divider
            const Divider(
              color: Colors.lightBlue,
              endIndent: 25,
              indent: 25,
            ),

            //edit profile button
            _OptionItem(
                icon: const Icon(
                  Icons.edit_note_rounded,
                  color: Colors.lightBlue,
                ),
                name: 'Edit Your Profile',
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: APIs.me)));
                })),

            //divider
            const Divider(
              color: Colors.lightBlue,
              endIndent: 25,
              indent: 25,
            ),

            //profile button
            _OptionItem(
                icon: const Icon(
                  Icons.info_rounded,
                  color: Colors.lightBlue,
                ),
                name: 'About',
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()));
                })),

            //divider
            const Divider(
              color: Colors.lightBlue,
              endIndent: 25,
              indent: 25,
            ),

            //logout button
            // _OptionItem(
            //   icon: Icon(
            //     Icons.logout_rounded,
            //     color: Colors.red,
            //   ),
            //   name: 'Logout',
            //   onTap: (() async {
            //     // Navigator.pop(context);
            //     //for showing progress dialog
            //     Dialogs.showProgressBar(context);

            //     await APIs.updateActiveStatus(false);

            //     //sign out from app
            //     await APIs.auth.signOut().then((value) async {
            //       await GoogleSignIn().signOut().then((value) {
            //         //for hiding progress dialog
            //         Navigator.pop(context);

            //         //for moving to home screen
            //         Navigator.pop(context);

            //         APIs.auth = FirebaseAuth.instance;

            //         //replacing home screen with login screen
            //         Navigator.pushReplacement(context,
            //             MaterialPageRoute(builder: (_) => const LoginScreen()));
            //       });
            //     });
            //   }),
            // ),

            //logout button
            InkWell(
              onTap: (() async {
                // Navigator.pop(context);
                //for showing progress dialog
                Dialogs.showProgressBar(context);

                await APIs.updateActiveStatus(false);

                //sign out from app
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //for hiding progress dialog
                    Navigator.pop(context);

                    //for moving to home screen
                    Navigator.pop(context);

                    APIs.auth = FirebaseAuth.instance;

                    //replacing home screen with login screen
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  });
                });
              }),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                    ),
                    Flexible(
                        child: Text(
                      '   Logout',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '   $name',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ))
          ],
        ),
      ),
    );
  }
}
