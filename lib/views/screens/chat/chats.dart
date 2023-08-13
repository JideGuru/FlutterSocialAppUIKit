import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_app_ui/util/chat_util.dart';
import 'package:social_app_ui/views/widgets/chat_item.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("채팅"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('chats')
            .doc('myEmail.jbnu.ac.kr')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var chatList = getChatsFromSnapshot(snapshot);
            print(chatList[0].nickname);
            return ListView.separated(
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
              itemCount: chatList.length,
              itemBuilder: (BuildContext context, int index) {
                Chat chat = chatList[index];
                print('chat done');
                return ChatItem(
                  email: chat.email,
                  nickname: chat.nickname,
                  message: chat.conversations.last['message'],
                  time: chat.conversations.last['time'].toString(),
                );
              },
            );
          } else
            return Center(
              child: LoadingAnimationWidget.waveDots(
                color: Colors.grey,
                size: 50,
              ),
            );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
