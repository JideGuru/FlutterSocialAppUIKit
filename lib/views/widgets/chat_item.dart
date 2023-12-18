import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/chat/conversation.dart';

class ChatItem extends StatefulWidget {
  final User me, other;
  final List<dynamic> chats;
  final bool marked;

  ChatItem(
      {super.key,
      required this.me,
      required this.other,
      required this.chats,
      this.marked = false});

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    var recentChat = widget.chats.last;
    var recentTime =
        (recentChat['time'] as Timestamp).toDate().toIso8601String().split('T');
    var notRead = widget.chats
        .where((conversation) =>
            !conversation['read'] && conversation['sender'] != widget.me.email)
        .length;
    var now = Timestamp.now().toDate().toIso8601String().split('T');
    var marked = widget.marked;
    return Container(
      decoration: BoxDecoration(color: Color.fromRGBO(245, 245, 245, 0.664)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: marked
              ? Row(
                  children: [
                    Text(
                      "${widget.other.essentials['nickname']}",
                      maxLines: 1,
                      style: notRead > 0
                          ? TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: GoogleFonts.inter().fontFamily,
                              fontSize: 15,
                            )
                          : TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: GoogleFonts.inter().fontFamily,
                              fontSize: 15,
                              color: Color.fromRGBO(0, 0, 0, 0.76),
                            ),
                    ),
                    Image.asset(
                      'assets/images/pin.png',
                      width: 13,
                      height: 15.588,
                    )
                  ],
                )
              : Text(
                  "${widget.other.essentials['nickname']}",
                  maxLines: 1,
                  style: notRead > 0
                      ? TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontSize: 15,
                        )
                      : TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontSize: 15,
                          color: Color.fromRGBO(0, 0, 0, 0.76),
                        ),
                ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("${recentChat['message']}",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: notRead > 0
                    ? TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontSize: 15,
                      )
                    : TextStyle(
                        color: Color.fromRGBO(130, 130, 147, 1.0),
                        fontWeight: FontWeight.w300,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontSize: 15,
                      )),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                now[0] == recentTime[0]
                    ? recentTime[1].substring(0, 5)
                    : now[0],
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: notRead > 0,
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 31, 0, 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(90),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      notRead.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigate.pushPage(
              context,
              Conversation(
                me: widget.me,
                other: widget.other,
                chats: widget.chats,
              ),
            );
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PopupMenuItem(
                          child: Text(widget.marked
                              ? consts['unbookmark'].toString()
                              : consts['bookmark'].toString()),
                          onTap: () {
                            setState(() {
                              marked = !marked;
                              chatsColRef.doc(widget.me.email).update(
                                {
                                  FieldPath([widget.other.email, 'marked']):
                                      marked
                                },
                              );
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Text(consts['close'].toString()),
                          onTap: () {
                            chatsColRef.doc(widget.me.email).update(
                              {
                                FieldPath(
                                  [widget.other.email],
                                ): FieldValue.delete(),
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
