import 'package:flutter/material.dart';
import 'package:snapam/util/data.dart';
import 'package:snapam/views/components/chat_item.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat'
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(10),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Divider(),
            ),
          );
        },
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          Map chat = chats[index];
          return ChatItem(
            dp: chat['dp'],
            name: chat['name'],
            isOnline: chat['isOnline'],
            counter: chat['counter'],
            msg: chat['msg'],
            time: chat['time'],
          );
        },
      ),
    );
  }
}
