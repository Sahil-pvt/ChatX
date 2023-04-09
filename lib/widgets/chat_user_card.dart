import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatx/api/apis.dart';
import 'package:chatx/helper/my_date_util.dart';
import 'package:chatx/models/chat_user.dart';
import 'package:chatx/models/message.dart';
import 'package:chatx/screens/chat_screen.dart';
import 'package:chatx/widgets/Dialogs/profile_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 1,
      //color: const Color.fromARGB(255, 4, 33, 81),
      color: const Color.fromARGB(255, 2, 22, 53),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: InkWell(
          onTap: () {
            //for navigating to chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;

              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                _message = list[0];
              }

              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${widget.user.email}                                                                     ',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 10, 106, 185),
                        fontStyle: FontStyle.italic,
                        fontSize: 12),
                  ),
                  ListTile(
                    //user profile picture
                    // leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
                    leading: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => ProfileDialog(
                                  user: widget.user,
                                ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(23),
                        child: CachedNetworkImage(
                          width: 45,
                          height: 45,
                          imageUrl: widget.user.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                    ),

                    //user email
                    // title: Text(
                    //   widget.user.email,
                    //   style: const TextStyle(
                    //       color: Colors.white,
                    //       ),
                    // ),

                    //user name
                    // title: Text(
                    //   '${widget.user.email}\n${widget.user.name}',
                    //   style: const TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.w600,
                    //       letterSpacing: 0.8),
                    // ),

                    //user name
                    title: Text(
                      widget.user.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.8),
                    ),

                    //last message
                    subtitle: Text(
                      _message != null
                          ? _message!.type == Type.image
                              ? '📷 Image'
                              : _message!.msg
                          : widget.user.about,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                      //fontStyle: FontStyle.italic),
                      maxLines: 1,
                    ),

                    //last message time
                    trailing: _message == null
                        ? null //show nothing when no message is sent
                        : _message!.read.isEmpty &&
                                _message!.fromId != APIs.user.uid
                            ?
                            //show for unread message
                            Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            //message sent time
                            : Text(
                                MyDateUtil.getLastMessageTime(
                                    context: context, time: _message!.sent),
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
