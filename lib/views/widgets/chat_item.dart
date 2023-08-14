import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/chat_util.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/chat/conversation.dart';

class ChatItem extends StatefulWidget {
  final User user;
  final Chat chat;

  ChatItem({
    super.key,
    required this.user,
    required this.chat,
  });

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    var recentConversation = widget.chat.conversations.last;
    DateTime recentTime = (recentConversation['time'] as Timestamp).toDate();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          "${widget.chat.nickname}",
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
            SizedBox(
              height: 10,
            ),
            Text(
              "${recentTime.hour}:${recentTime.minute}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
        onTap: () {
          Navigate.pushPage(
            context,
            Conversation(
              user: widget.user,
              chat: widget.chat,
            ),
          );
        },
      ),
    );
  }
}
