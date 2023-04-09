import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatx/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../screens/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: const Color.fromARGB(255, 11, 68, 153).withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: 200,
        height: 330,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(110),
                  child: CachedNetworkImage(
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  )),
            ),

            //user name
            Positioned(
              left: 15,
              top: 15,
              width: 220,
              child: Text(
                user.name,
                style: const TextStyle(
                    color: Colors.white,
                    //fontStyle: FontStyle.italic,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),

            // const Divider(
            //   height: 78,
            //   thickness: 2,
            //   color: Color.fromARGB(255, 0, 140, 255),
            // ),

            //info button
            Positioned(
                right: 5,
                top: 5,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewProfileScreen(user: user)));
                  },
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  shape: const CircleBorder(),
                  color: const Color.fromARGB(187, 255, 255, 255),
                  elevation: 5,
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Color.fromARGB(255, 8, 52, 118),
                    size: 28,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
