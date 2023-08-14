import 'package:flutter/material.dart';
import 'package:social_app_ui/util/chat_util.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/views/screens/chat/conversation.dart';

class ChatItem extends StatefulWidget {
  final String email;
  final Chat chat;

  ChatItem({
    super.key,
    required this.email,
    required this.chat,
  });

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    var recentConversation = widget.chat.conversations.last;
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
        subtitle: Text(
          "${recentConversation['message']}",
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              "${recentConversation['time'].toString()}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
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
              email: widget.email,
              chat: widget.chat,
            ),
          );
        },
      ),
    );
  }
}
