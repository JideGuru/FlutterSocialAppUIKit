import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/chat.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/extensions.dart';
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
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            var chatsFromSnapshot = getChatsFromSnapshot(snapshot);
            var markedChats = [], chats = [];
            if (chatsFromSnapshot.length > 0) {
              chatsFromSnapshot.sort(
                (a, b) {
                  var aTime =
                      (a.conversations.last['time'] as Timestamp).toDate();
                  var bTime =
                      (b.conversations.last['time'] as Timestamp).toDate();
                  return bTime.compareTo(aTime);
                },
              );
              markedChats = List.from(
                chatsFromSnapshot.where(
                  (chat) => chat.conversations.last['marked'],
                ),
              );
              chats = List.from(
                chatsFromSnapshot.where(
                  (chat) => !chat.conversations.last['marked'],
                ),
              );
              markedChats.addAll(chats);
              chats = markedChats;
            }
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
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                Chat chat = chats[index];
                return FutureBuilder(
                  future: usersColRef.doc(chat.email).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var other = User.fromFirestore(snapshot.data!);
                      return ChatItem(
                          me: widget.user, other: other, chat: chat);
                    } else
                      return Container();
                  },
                );
              },
            ).fadeInList(1, false);
          } else
            return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
