import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatx/helper/my_date_util.dart';
import 'package:chatx/models/chat_user.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//to view profile of user

class UserProfileScreen extends StatefulWidget {
  final ChatUser me;
  const UserProfileScreen({super.key, required this.me});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 13, 31),
        appBar: AppBar(
          title: Text(
            widget.me.name,
            style: const TextStyle(
                color: Colors.white,
                //fontStyle: FontStyle.italic,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                fontSize: 17.5),
          ),
          elevation: 1,
          shadowColor: Colors.blue,
        ),

        floatingActionButton: //user about
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Joined On: ',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
            Text(
              MyDateUtil.getLastMessageTime(
                  context: context, time: widget.me.createdAt, showYear: true),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),

        //body
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //for adding some space
                const SizedBox(
                  width: 1000,
                  height: 50,
                ),
                //user profile picture
                ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: CachedNetworkImage(
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      imageUrl: widget.me.image,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    )),
                //for adding some space
                const SizedBox(
                  height: 30,
                ),

                Text(
                  widget.me.email,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),

                //for adding some space
                const SizedBox(
                  height: 25,
                ),

                //user about
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('About: ',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Text(
                      widget.me.about,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
