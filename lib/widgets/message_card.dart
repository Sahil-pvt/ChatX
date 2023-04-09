import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatx/api/apis.dart';
import 'package:chatx/helper/my_date_util.dart';
import 'package:chatx/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../helper/dialogs.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  //sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and reciever are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 2 : 10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 0, 115, 168)),
                color: const Color.fromARGB(255, 3, 34, 80),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(color: Colors.white),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),

        //message time
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.white54),
          ),
        ),
      ],
    );
  }

  //our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            const SizedBox(
              width: 18,
            ),

            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
              ),

            const SizedBox(
              width: 8,
            ),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.white54),
            ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 2 : 10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 0, 140, 255)),
                color: const Color.fromARGB(255, 14, 74, 164),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(color: Colors.white),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  //bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color.fromARGB(255, 0, 44, 79),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            // padding: const EdgeInsets.only(top: 25, bottom: 45),
            children: [
              Container(
                //blue divider
                height: 4,
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 150),
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(8)),
              ),

              //copy option
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: const Icon(
                        Icons.copy_all_rounded,
                        color: Colors.lightBlue,
                      ),
                      name: 'Copy Message',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);
                          Dialogs.showSnackbar(context, 'Message Copied !');
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: const Icon(
                        Icons.download_rounded,
                        color: Colors.lightBlue,
                      ),
                      name: 'Save Image To Gallery',
                      onTap: () async {
                        try {
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'ChatX')
                              .then((success) {
                            //for hiding bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Image Successfully Saved !');
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImg: $e');
                        }
                      }),

              //divider
              if (isMe)
                const Divider(
                  color: Colors.lightBlue,
                  endIndent: 25,
                  indent: 25,
                ),

              //edit option
              // if (widget.message.type == Type.text && isMe)
              //   _OptionItem(
              //       icon: const Icon(
              //         Icons.edit,
              //         color: Colors.lightBlue,
              //       ),
              //       name: 'Edit Message',
              //       onTap: () {
              //         //for hiding bottom sheet
              //         Navigator.pop(context);
              //         _showMessageUpdateDialog();
              //       }),

              //divider
              if (isMe)
                const Divider(
                  color: Colors.lightBlue,
                  endIndent: 25,
                  indent: 25,
                ),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //divider
              const Divider(
                color: Colors.lightBlue,
                endIndent: 25,
                indent: 25,
              ),

              //sent time
              _OptionItem(
                  icon: Icon(
                    Icons.send_rounded,
                    color: Colors.greenAccent.shade400,
                  ),
                  name:
                      'Sent At:  ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.blueAccent,
                  ),
                  name: widget.message.read.isEmpty
                      ? "Read At:  Not seen yet"
                      : 'Read At:  ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),

              const SizedBox(
                height: 30,
              )
            ],
          );
        });
  }

  // //dialog for updating message content
  // void _showMessageUpdateDialog() {
  //   String updatedMsg = widget.message.msg;

  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             contentPadding: const EdgeInsets.only(
  //                 left: 24, right: 24, top: 20, bottom: 10),

  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20)),

  //             //title
  //             title: Row(
  //               children: const [
  //                 Icon(
  //                   Icons.message,
  //                   color: Colors.blue,
  //                   size: 28,
  //                 ),
  //                 Text(' Update Message')
  //               ],
  //             ),

  //             //content
  //             content: TextFormField(
  //               initialValue: updatedMsg,
  //               maxLines: null,
  //               onChanged: (value) => updatedMsg = value,
  //               decoration: InputDecoration(
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(15))),
  //             ),

  //             //actions
  //             actions: [
  //               //cancel button
  //               MaterialButton(
  //                   onPressed: () {
  //                     //hide alert dialog
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text(
  //                     'Cancel',
  //                     style: TextStyle(color: Colors.blue, fontSize: 16),
  //                   )),

  //               //update button
  //               MaterialButton(
  //                   onPressed: () {
  //                     //hide alert dialog
  //                     Navigator.pop(context);
  //                     APIs.updateMessage(widget.message, updatedMsg);
  //                   },
  //                   child: const Text(
  //                     'Update',
  //                     style: TextStyle(color: Colors.blue, fontSize: 16),
  //                   ))
  //             ],
  //           ));
  // }
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
                  color: Colors.lightBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ))
          ],
        ),
      ),
    );
  }
}
