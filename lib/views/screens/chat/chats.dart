import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_app_ui/util/chat_util.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/chat_item.dart';

class Chats extends StatefulWidget {
  final User user;
  Chats({
    super.key,
    required this.user,
  });
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
        title: Text(
          "채팅",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: chatsColRef.doc(widget.user.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var chatsFromSnapshot = getChatsFromSnapshot(snapshot);
            chatsFromSnapshot.sort(
              (a, b) {
                var aTime =
                    (a.conversations.last['time'] as Timestamp).toDate();
                var bTime =
                    (b.conversations.last['time'] as Timestamp).toDate();
                return bTime.compareTo(aTime);
              },
            );
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
              itemCount: chatsFromSnapshot.length,
              itemBuilder: (BuildContext context, int index) {
                Chat chat = chatsFromSnapshot[index];
                return ChatItem(
                  user: widget.user,
                  chat: chat,
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
