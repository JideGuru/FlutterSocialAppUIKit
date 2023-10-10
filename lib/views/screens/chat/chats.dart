import 'package:flutter/material.dart';
import 'package:social_app_ui/util/chat.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/chat_item.dart';

class Chats extends StatefulWidget {
  final User me;
  Chats({
    super.key,
    required this.me,
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
        stream: chatsColRef.doc(widget.me.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            var chatFromFirestore = Chat.fromFirestore(snapshot.data!);
            var chatMaps = chatFromFirestore.chatMaps;
            var orderedEmails = chatFromFirestore.orderedEmails;

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
              itemCount: orderedEmails.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  future: usersColRef.doc(orderedEmails[index]).get(),
                  builder: (context, snapshot) {
                    var email = orderedEmails[index];
                    var chats = chatMaps[email]['chats'];
                    var marked = false;
                    if ((chatMaps[email] as Map<String, dynamic>)
                        .containsKey('marked'))
                      marked = chatMaps[email]['marked'];
                    if (snapshot.connectionState == ConnectionState.done) {
                      var other = User.fromFirestore(snapshot.data!);
                      return ChatItem(
                        me: widget.me,
                        other: other,
                        chats: chats,
                        marked: marked,
                      );
                    } else
                      return Container();
                  },
                );
              },
            ).fadeInList(3, false);
          } else
            return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
