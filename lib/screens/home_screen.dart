import 'dart:developer';

import 'package:chatx/helper/dialogs.dart';
import 'package:chatx/models/chat_user.dart';
import 'package:chatx/screens/side_bar.dart';
import 'package:chatx/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/apis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all users
  List<ChatUser> _list = [];

  //for storing search items
  final List<ChatUser> _searchList = [];

  //for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume --> active or online
    //pause --> inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: (() {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        }),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 0, 12),
          drawer: const SideBarScreen(),
          //app bar
          appBar: AppBar(
            // leading: IconButton(
            //   onPressed: () {
            //     const SideBarScreen();
            //   },
            //   icon: const Icon(Icons.menu_rounded),
            // ),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      //border: InputBorder.none,
                      hintText: "Email, Name, ....",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 1, 89, 161)),
                      // filled: true,
                      // fillColor: Color.fromARGB(255, 4, 39, 91),
                    ),
                    autofocus: true,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 17, letterSpacing: 0.5),

                    //when search text changes then update search list
                    onChanged: (val) {
                      //search logic
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : const Text(
                    'ChatX',
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.5),
                  ),
            elevation: 1,
            shadowColor: Colors.blue,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : CupertinoIcons.search)),
              // IconButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (_) => ProfileScreen(
              //                     user: APIs.me,
              //                   )));
              //     },
              //     icon: const Icon(
              //       CupertinoIcons.person_crop_circle_fill,
              //     ))
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {
                _addChatUserDialog();
              },
              backgroundColor: const Color.fromARGB(255, 0, 140, 255),
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),

            //get id of only known users
            builder: ((context, snapshot) {
              switch (snapshot.connectionState) {

                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: APIs.getAllUsers(
                          snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                      //get only those user, who's ids are provided
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {

                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                          // return const Center(
                          //   child: CircularProgressIndicator(),
                          // );
                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              final data = snapshot.data?.docs;
                              _list = data
                                      ?.map((e) => ChatUser.fromJson(e.data()))
                                      .toList() ??
                                  [];
                            }

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: _isSearching
                                      ? _searchList.length
                                      : _list.length,
                                  padding: const EdgeInsets.only(top: 6),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // return Text(
                                    //   'Name: ${list[index]}',
                                    //   style: TextStyle(color: Colors.white),
                                    // );
                                    return ChatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : _list[index],
                                    );
                                  });
                            } else {
                              return Center(
                                  child: Text(
                                'No Connections Found !',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue.shade800,
                                ),
                              ));
                            }
                        }
                      });
              }
            }),
          ),
        ),
      ),
    );
  }

  //for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              backgroundColor: const Color.fromARGB(255, 0, 44, 79),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add_rounded,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(
                    '   Add User',
                    style: TextStyle(
                        color: Colors.blue,
                        // fontStyle: FontStyle.italic,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.5),
                  )
                ],
              ),

              //content
              content: TextFormField(
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 10, 89, 153)),
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 10, 89, 153)),
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "User Email Id",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 2, 26, 62),
                ),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      // APIs.updateMessage(widget.message, updatedMsg);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists !');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add User',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
