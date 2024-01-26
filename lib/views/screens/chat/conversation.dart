import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app_ui/util/chat.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/notify.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/other_profile.dart';
import 'package:social_app_ui/views/widgets/chat_bubble.dart';

class Conversation extends StatefulWidget {
  final User me, other;
  final List<dynamic> chats;
  final bool marked;
  Conversation({
    super.key,
    required this.me,
    required this.other,
    required this.chats,
    this.marked = false,
  });
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var marked = widget.marked;
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
                    Row(
                      children: [
                        Text(
                          widget.other.essentials['nickname'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: Colors.black),
                        ),
                        // Visibility(
                        //   visible: widget.marked,
                        //   child: Image.asset(
                        //     'assets/images/pin.png',
                        //     width: 13,
                        //     height: 15.588,
                        //   ),
                        // )
                      ],
                    ),
                    Text(
                      widget.other.email,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: Colors.black),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.report,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("신고하시겠습니까?"),
                          actions: [
                            ElevatedButton(
                              child: Text(
                                "신고",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () async {
                                String _formatTime(DateTime dateTime) {
                                  String period =
                                      dateTime.hour < 12 ? '오전' : '오후';
                                  int hour = dateTime.hour % 12 == 0
                                      ? 12
                                      : dateTime.hour % 12;
                                  String minute = dateTime.minute
                                      .toString()
                                      .padLeft(2, '0');
                                  String second = dateTime.second
                                      .toString()
                                      .padLeft(2, '0');
                                  return '$period $hour시 $minute분 $second초';
                                }

                                DateTime now = DateTime.now();
                                String formattedDateTime =
                                    "${now.year}년 ${now.month}월 ${now.day}일 ${_formatTime(now)}";
                                print(formattedDateTime);

                                var reportDoc = await FirebaseFirestore.instance
                                    .collection('report')
                                    .doc(widget.other.email)
                                    .get();

                                var newReporter = {
                                  'email': widget.me.email,
                                  'time': formattedDateTime,
                                };
                                var existingReporters = reportDoc.exists &&
                                        reportDoc.data()!.containsKey("신고자")
                                    ? List.from(reportDoc["신고자"])
                                    : [];
                                existingReporters.add(newReporter);
                                await FirebaseFirestore.instance
                                    .collection('report')
                                    .doc(widget.other.email)
                                    .set(
                                  {
                                    '신고자': existingReporters,
                                  },
                                );
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text("신고되었습니다."),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("확인"),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            ElevatedButton(
                                child: Text(
                                  "취소",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      });
                },
              )
            ],
          ),
          onTap: () {
            Navigate.pushPage(
              context,
              OtherProfile(
                other: widget.other,
              ),
            );
          },
        ).fadeInList(1, false),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(marked
                      ? consts['unbookmark'].toString()
                      : consts['bookmark'].toString()),
                  onTap: () {
                    setState(() {
                      // marked = !marked;
                      // print(marked);
                      chatsColRef.doc(widget.me.email).update(
                        {
                          FieldPath([widget.other.email, 'marked']): !marked,
                        },
                      );
                      // print(marked);
                    });
                  },
                ),
                PopupMenuItem(
                  child: Text(consts['leave'].toString()),
                  onTap: () {
                    Navigator.pop(context);
                    chatsColRef.doc(widget.me.email).update(
                      {
                        FieldPath(
                          [widget.other.email],
                        ): FieldValue.delete(),
                      },
                    );
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: chatsColRef.doc(widget.me.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            var chats = Chat.fromFirestore(snapshot.data!);
            var conversation = [];
            var lastReadIndex = -1;

            if (chats.chatMaps.containsKey(widget.other.email)) {
              conversation = chats.chatMaps[widget.other.email]['chats'];
              marked = chats.chatMaps[widget.other.email]['marked'] ?? false;
              for (var conv in conversation) {
                if (widget.other.email == conv['sender'])
                  conv['read'] = true;
                else if (widget.me.email == conv['sender'] && conv['read'])
                  lastReadIndex = conversation.indexOf(conv);
              }
              chatsColRef.doc(widget.me.email).update({
                FieldPath([widget.other.email, 'chats']): conversation
              });
            }
            chatsColRef.doc(widget.other.email).get().then(
              (value) {
                var otherChats = Chat.fromFirestore(value);
                if (otherChats.chatMaps.containsKey(widget.me.email)) {
                  var conversation =
                      otherChats.chatMaps[widget.me.email]['chats'] ?? [];
                  for (var conv in conversation) {
                    if (widget.other.email == conv['sender'])
                      conv['read'] = true;
                  }
                  chatsColRef.doc(widget.other.email).update({
                    FieldPath([widget.me.email, 'chats']): conversation
                  });
                }
              },
            );

            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: conversation.length,
                      itemBuilder: (context, index) {
                        var itemIndex = conversation.length - index - 1;
                        var befDay = 'a';
                        var curDay = 'b';
                        if (itemIndex > 0 && itemIndex < conversation.length) {
                          befDay =
                              (conversation[itemIndex - 1]['time'] as Timestamp)
                                  .toDate()
                                  .toIso8601String()
                                  .split('T')[0];
                          curDay =
                              (conversation[itemIndex]['time'] as Timestamp)
                                  .toDate()
                                  .toIso8601String()
                                  .split('T')[0];
                        }

                        return ChatBubble(
                          withRead: itemIndex == lastReadIndex,
                          withDayBar: befDay != curDay,
                          message: conversation[itemIndex],
                          sender: widget.me.email ==
                                  conversation[itemIndex]['sender']
                              ? Owner.MINE
                              : Owner.OTHERS,
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
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10),
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        hintText: consts['type-your-message']
                                            .toString(),
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromRGBO(
                                                199, 190, 190, 1))),
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    maxLines: null,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    Map<String, dynamic> msg = {};
                                    msg['message'] = controller.text;
                                    msg['read'] = false;
                                    msg['sender'] = widget.me.email;
                                    msg['time'] = Timestamp.now();
                                    chatsColRef.doc(widget.me.email).update(
                                      {
                                        FieldPath(
                                                [widget.other.email, 'chats']):
                                            FieldValue.arrayUnion([msg])
                                      },
                                    );
                                    chatsColRef.doc(widget.other.email).update(
                                      {
                                        FieldPath([widget.me.email, 'chats']):
                                            FieldValue.arrayUnion([msg])
                                      },
                                    );
                                    if (widget.me.essentials['notification'] ==
                                        0) {
                                      Notify.notify(
                                        from: widget.me,
                                        to: widget.other,
                                        message: msg['message'],
                                      );
                                      controller.text = '';
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 10,
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
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}