import 'package:flutter/material.dart';
import 'package:snapam/util/data.dart';
import 'package:snapam/views/components/chat_item.dart';

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
    );
  }
}
