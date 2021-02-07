import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:snapam/views/pages/chat/chat_list.dart';
import 'package:snapam/views/pages/chat/conversation.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Chat')),
      body: ScreenTypeLayout(
        mobile: ChatList(),
        desktop: buildDesktop(),
        tablet: buildDesktop(),
      ),
    );
  }

  buildDesktop() {
    return Row(
      children: [
        Container(width: 400.0, child: ChatList()),
        VerticalDivider(thickness: 1, width: 1),
        Flexible(child: Conversation()),
      ],
    );
  }
}
