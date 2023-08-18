import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/chat.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/chat/conversation.dart';

class ChatItem extends StatefulWidget {
  final User me, other;
  final Chat chat;

  ChatItem({
    super.key,
    required this.me,
    required this.other,
    required this.chat,
  });

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    var recentConversation = widget.chat.conversations.last;
    var recentTime = (recentConversation['time'] as Timestamp)
        .toDate()
        .toIso8601String()
        .split('T');
    var notRead = widget.chat.conversations
        .where((conversation) =>
            !conversation['read'] &&
            conversation['senderEmail'] != widget.me.email)
        .length;
    var now = Timestamp.now().toDate().toIso8601String().split('T');
    var mark = recentConversation['marked'] ? '✓' : '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          "${widget.chat.conversations.last['otherNickname']} ${mark}",
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "${recentConversation['message']}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              now[0] == recentTime[0] ? recentTime[1].substring(0, 5) : now[0],
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
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
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
              user: widget.me,
              other: widget.other,
              chat: widget.chat,
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
                        child: Text(widget.chat.conversations.last['marked']
                            ? '즐겨찾기 해제'
                            : '즐겨찾기'),
                        onTap: () {
                          widget.chat.conversations.last['marked'] =
                              !widget.chat.conversations.last['marked'];

                          chatsColRef.doc(widget.me.email).update(
                            {
                              FieldPath([widget.chat.email]):
                                  widget.chat.conversations,
                            },
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: Text('나가기'),
                        onTap: () {
                          chatsColRef.doc(widget.me.email).update(
                            {
                              FieldPath(
                                [widget.chat.email],
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
    );
  }
}
