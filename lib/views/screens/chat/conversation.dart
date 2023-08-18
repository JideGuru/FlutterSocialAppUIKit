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
  final User user, other;
  final Chat chat;
  Conversation({
    super.key,
    required this.user,
    required this.other,
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
        title: InkWell(
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
                      widget.other.essentials['nickname'],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      widget.other.email,
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
              OtherProfile(user: widget.other),
            );
          },
        ).fadeInList(1, false),
        actions: <Widget>[
          Visibility(
            visible: widget.chat.conversations.length > 0,
            child: StreamBuilder(
              stream: chatDocRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var chat = getChatFromSnapshot(widget.other.email, snapshot);
                  return PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text(chat.conversations.last['marked']
                              ? '즐겨찾기 해제'
                              : '즐겨찾기'),
                          onTap: () {
                            chat.conversations.last['marked'] =
                                !chat.conversations.last['marked'];

                            chatDocRef.update(
                              {
                                FieldPath([chat.email]): chat.conversations,
                              },
                            );
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
                  );
                } else
                  return Container();
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
                var data = snapshot.data!.data()!;
                var conversations = data.containsKey(widget.user.email)
                    ? data[widget.user.email]
                    : [];
                var otherChat = Chat(
                  email: widget.user.email,
                  conversations: conversations,
                );
                if (myChat.conversations.isNotEmpty) {
                  for (var conversation in otherChat.conversations) {
                    if (conversation['senderEmail'] != widget.user.email)
                      conversation['read'] = true;
                  }
                  for (var converstaion in myChat.conversations) {
                    if (converstaion['senderEmail'] != widget.user.email)
                      converstaion['read'] = true;
                  }
                  chatsColRef.doc(widget.chat.email).update(
                    {
                      FieldPath(
                        [widget.user.email],
                      ): otherChat.conversations,
                    },
                  );
                  chatsColRef.doc(widget.user.email).update(
                    {
                      FieldPath(
                        [widget.chat.email],
                      ): myChat.conversations,
                    },
                  );
                }
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
                                        print(conversation);
                                        conversation['message'] =
                                            controller.text;
                                        conversation['otherNickname'] =
                                            widget.other.essentials['nickname'];
                                        conversation['read'] = false;
                                        conversation['senderEmail'] =
                                            widget.user.email;
                                        conversation['marked'] =
                                            myChat.conversations.length == 0
                                                ? false
                                                : myChat.conversations
                                                    .last['marked'];
                                        conversation['time'] = Timestamp.now();
                                        print(conversation);
                                        chatsColRef
                                            .doc(widget.user.email)
                                            .update({
                                          FieldPath([myChat.email]):
                                              FieldValue.arrayUnion(
                                                  [conversation])
                                        });
                                        conversation['otherNickname'] =
                                            widget.user.essentials['nickname'];
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
