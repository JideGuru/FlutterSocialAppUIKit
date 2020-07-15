import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/components/chat_bubble.dart';
import 'package:social_app_ui/models/message.dart';
import 'package:social_app_ui/models/user.dart';
import 'package:social_app_ui/util/enum/message_type.dart';
import 'package:social_app_ui/view_models/chats/conversation_view_model.dart';
import 'package:social_app_ui/view_models/user/user_view_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class Conversation extends StatefulWidget {
  final String userId;
  String chatId;

  Conversation({@required this.userId, @required this.chatId});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final Firestore firestore = Firestore.instance;

  FocusNode focusNode = FocusNode();
  ScrollController controller = ScrollController();
  TextEditingController messageTEC = TextEditingController();
  bool isFirst = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      focusNode.unfocus();
    });
    if(widget.chatId == 'newChat'){
      isFirst = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserViewModel>(context, listen: false).user;
    return Consumer<ConversationViewModel>(
      builder: (BuildContext context, viewModel, Widget child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 3,
            titleSpacing: 0,
            title: buildUserName(),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: StreamBuilder(
                    stream: messageListStream(widget.chatId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List messages = snapshot.data.documents;

                        return ListView.builder(
                          controller: controller,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemCount: messages.length,
                          reverse: true,
                          itemBuilder: (BuildContext context, int index) {
                            Message message = Message.fromJson(
                                messages.reversed.toList()[index].data);
                            return ChatBubble(
                              message: '${message.content}',
                              time: message.time,
                              type: message.type,
                              isMe: message.senderUid == user.uid,
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomAppBar(
                    elevation: 10,
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 100,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Feather.image,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {},
                          ),
                          Flexible(
                            child: TextField(
                              controller: messageTEC,
                              focusNode: focusNode,
                              style: TextStyle(
                                fontSize: 15.0,
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintText: "Write your message...",
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Feather.send,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              if(messageTEC.text.isNotEmpty){
                                sendMessage(viewModel, user);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildUserName() {
    return StreamBuilder(
      stream: firestore
          .collection('users')
          .document('${widget.userId}')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data;
          User user = User.fromJson(documentSnapshot.data);
          return InkWell(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Hero(
                    tag: user.name,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        '${user.profilePicture}',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${user.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        user.isOnline
                            ? 'online'
                            : 'last seen ${timeago.format(user.lastSeen.toDate())}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {},
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  sendMessage(ConversationViewModel viewModel, var user) async {
    String msg = messageTEC.text.trim();
    messageTEC.clear();
    Message message = Message(
      content: '$msg',
      senderUid: user.uid,
      type: MessageType.TEXT,
      time: Timestamp.now(),
    );

    if(msg.isNotEmpty){
      if(isFirst){
        print("FIRST");
        String id = await viewModel.sendFirstMessage(widget.userId, message);
        setState(() {
          widget.chatId = id;
        });
      }else{
        viewModel.sendMessage(
          widget.chatId,
          message,
        );
      }
    }
  }

  Stream<QuerySnapshot> messageListStream(String documentId) {
    return firestore
        .collection("chats")
        .document(documentId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
}
