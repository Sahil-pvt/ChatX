import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatx/models/chat_user.dart';
import 'package:chatx/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 13, 31),
        appBar: AppBar(
          title: const Text(
            'Your Profile',
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
                fontSize: 17.5),
          ),
          elevation: 1,
          shadowColor: Colors.blue,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
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
            },
            icon: const Icon(Icons.logout),
            backgroundColor: const Color.fromARGB(255, 249, 77, 77),
            label: const Text('Logout'),
          ),
        ),
        //body
        body: Form(
          key: _formKey,
          child: Padding(
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
                  Stack(
                    children: [
                      //profile picture
                      _image != null
                          ?

                          //local image
                          ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.file(
                                File(_image!),
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: CachedNetworkImage(
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(CupertinoIcons.person)),
                              )),

                      //edit image button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 80,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          color: Colors.blue,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                          ),
                        ),
                      )
                    ],
                  ),
                  //for adding some space
                  const SizedBox(
                    height: 30,
                  ),

                  Text(
                    widget.user.email,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 2, 103, 186), fontSize: 15),
                  ),

                  //for adding some space
                  const SizedBox(
                    height: 25,
                  ),

                  //name input field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 10, 89, 153)),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 10, 89, 153)),
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'eg. John Doe',
                      hintStyle: const TextStyle(color: Colors.white54),
                      label: const Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 2, 26, 62),
                    ),
                  ),

                  //for adding some space
                  const SizedBox(
                    height: 25,
                  ),

                  //about input field
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 10, 89, 153)),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 10, 89, 153)),
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "eg. Hey, I'm using ChatX",
                      hintStyle: const TextStyle(color: Colors.white54),
                      label: const Text(
                        'About',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 2, 26, 62),
                    ),
                  ),

                  //for adding some space
                  const SizedBox(
                    height: 30,
                  ),

                  //update profile button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(70, 40)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile Udated Successfully !');
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 23,
                    ),
                    label: const Text(
                      'UPDATE',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color.fromARGB(255, 0, 44, 79),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 25, bottom: 45),
            children: [
              //pick profile picture label
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                    fontSize: 17.5),
              ),

              const SizedBox(
                height: 45,
              ),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 0, 71, 129),
                          shape: const CircleBorder(),
                          fixedSize: const Size(100, 100)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 40,
                        );
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          // ignore: use_build_context_synchronously
                          Dialogs.showSnackbar(
                              context, 'Profile Picture Updated !');

                          //for hiding bottom sheet
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image.png')),
                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 0, 71, 129),
                          shape: const CircleBorder(),
                          fixedSize: const Size(100, 100)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 40,
                        );
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          // ignore: use_build_context_synchronously
                          Dialogs.showSnackbar(
                              context, 'Profile Picture Updated !');

                          //for hiding bottom sheet
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png'))
                ],
              )
            ],
          );
        });
  }
}
