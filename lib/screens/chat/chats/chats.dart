import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:social_app_ui/components/chat_item.dart';
import 'package:social_app_ui/util/data.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Feather.search,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Feather.edit_2,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
}
