import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/chat_util.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/other_profile.dart';
import 'package:social_app_ui/views/widgets/chat_bubble.dart';

class Conversation extends StatefulWidget {
  final User user;
  final Chat chat;
  Conversation({
    super.key,
    required this.user,
    required this.chat,
  });
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var chatDocRef = chatsColRef.doc(widget.user.email);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: FutureBuilder(
          future: usersColRef.doc(widget.chat.email).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var other = User.fromFirestore(snapshot.data!);
              return InkWell(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 0.0, right: 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            other.essentials['nickname'],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            other.email,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigate.pushPage(
                    context,
                    OtherProfile(user: other),
                  );
                },
              ).fadeInList(1, false);
            } else
              return SizedBox();
          },
        ),
        actions: <Widget>[
          Visibility(
            visible: widget.chat.conversations.length > 0,
            child: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text(widget.chat.conversations.last['marked']
                        ? '즐겨찾기 해제'
                        : '즐겨찾기'),
                    onTap: () {
                      // widget.chat.conversations.last['marked'] =
                      //     !widget.chat.conversations.last['marked'];

                      // chatDocRef.update(
                      //   {
                      //     FieldPath([widget.chat.email]):
                      //         widget.chat.conversations,
                      //   },
                      // );
                    },
                  ),
                  PopupMenuItem(
                    child: Text('나가기'),
                    onTap: () {
                      chatDocRef.update(
                        {
                          FieldPath(
                            [widget.chat.email],
                          ): FieldValue.delete(),
                        },
                      );
                      Navigator.pop(context);
                    },
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: chatsColRef.doc(widget.user.email).snapshots(),
        builder: (context, snapshot) {
          var myChat = widget.chat;
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            var conversations = snapshot.data!.data()![widget.chat.email] ?? [];
            myChat = Chat(
              email: myChat.email,
              conversations: conversations,
            );
          }
          return StreamBuilder(
            stream: chatsColRef.doc(widget.chat.email).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                var conversations =
                    snapshot.data!.data()![widget.user.email] ?? [];
                var otherChat = Chat(
                  email: widget.user.email,
                  conversations: conversations,
                );
                for (var conversation in otherChat.conversations)
                  conversation['read'] = true;
                chatsColRef.doc(widget.chat.email).update(
                  {
                    FieldPath(
                      [widget.user.email],
                    ): otherChat.conversations,
                  },
                );
                var read = false, readFlag = false;
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemCount: myChat.conversations.length,
                          reverse: true,
                          itemBuilder: (BuildContext context, int index) {
                            var lastIndex = myChat.conversations.length - 1;
                            var curIndex = lastIndex - index;
                            var conversation = myChat.conversations[curIndex];
                            var time = (conversation['time'] as Timestamp)
                                .toDate()
                                .toIso8601String()
                                .split('T');
                            bool dayBar = false;
                            if (curIndex == 0)
                              dayBar = true;
                            else {
                              var befConv = myChat.conversations[curIndex - 1];
                              var befTime = (befConv['time'] as Timestamp)
                                  .toDate()
                                  .toIso8601String()
                                  .split('T');
                              if (time[0] != befTime[0]) dayBar = true;
                            }
                            if (conversation['read'] &&
                                conversation['senderEmail'] != myChat.email &&
                                readFlag == false) {
                              read = true;
                              readFlag = true;
                            } else
                              read = false;
                            return ChatBubble(
                              read: read,
                              withDayBar: dayBar,
                              conversation: conversation,
                              sender:
                                  conversation['senderEmail'] == myChat.email
                                      ? Owner.OTHERS
                                      : Owner.MINE,
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomAppBar(
                          elevation: 10,
                          color: Theme.of(context).colorScheme.secondary,
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                width: MediaQuery.of(context).size.width - 25,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                constraints: BoxConstraints(
                                  maxHeight: 100,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: controller,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          hintText: "메시지를 작성해주세요.",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        cursorColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        maxLines: null,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.send,
                                      ),
                                      onPressed: () {
                                        Map<String, dynamic> conversation = {};
                                        conversation['message'] =
                                            controller.text;
                                        conversation['otherNickname'] = myChat
                                            .conversations
                                            .last['otherNickname'];
                                        conversation['read'] = false;
                                        conversation['senderEmail'] =
                                            widget.user.email;
                                        conversation['marked'] =
                                            myChat.conversations.length == 0
                                                ? false
                                                : myChat.conversations
                                                    .last['marked'];
                                        conversation['time'] = Timestamp.now();
                                        chatsColRef
                                            .doc(widget.user.email)
                                            .update({
                                          FieldPath([myChat.email]):
                                              FieldValue.arrayUnion(
                                                  [conversation])
                                        });
                                        conversation['otherNickname'] =
                                            widget.user.essentials['nickname'];
                                        conversation['read'] = read;
                                        conversation['marked'] =
                                            otherChat.conversations.length == 0
                                                ? false
                                                : otherChat.conversations
                                                    .last['marked'];
                                        chatsColRef.doc(myChat.email).update({
                                          FieldPath([widget.user.email]):
                                              FieldValue.arrayUnion(
                                                  [conversation])
                                        });
                                        controller.text = '';
                                        // mounted ? setState(() {}) : dispose();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else
                return Container();
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
