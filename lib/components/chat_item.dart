import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/components/time_text.dart';
import 'package:social_app_ui/models/user.dart';
import 'package:social_app_ui/util/enum/message_type.dart';
import 'package:social_app_ui/views/chat/conversation/conversation.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatItem extends StatelessWidget {
  final String userId;
  final Timestamp time;
  final String msg;
  final int messageCount;
  final String chatId;
  final MessageType type;
  final String currentUserId;

  ChatItem({
    Key key,
    @required this.userId,
    @required this.time,
    @required this.msg,
    @required this.messageCount,
    @required this.chatId,
    @required this.type,
    @required this.currentUserId,
  }) : super(key: key);

  final Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore.collection('users').document('$userId').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data;
          User user = User.fromJson(documentSnapshot.data);

          return ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: Stack(
              children: <Widget>[
                Hero(
                  tag: user.name,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      '${user.profilePicture}',
                    ),
                    radius: 25.0,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: user?.isOnline ?? false
                              ? Color(0xff00d72f)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        height: 11,
                        width: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              '${user.name}',
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              type == MessageType.IMAGE ? "IMAGE" : "$msg",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 10),
                TimeText(
                  child: Text(
                    "${timeago.format(time.toDate())}",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                buildCounter(context),
              ],
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Conversation(
                      userId: userId,
                      chatId: chatId,
                    );
                  },
                ),
              );
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  buildCounter(BuildContext context) {
    return StreamBuilder(
      stream: messageBodyStream(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          DocumentSnapshot snap = snapshot.data;
          Map usersReads = snap.data['reads']??{};
          int readCount = usersReads[currentUserId]??0;
          int counter = messageCount - readCount;
          if (counter == 0) {
            return SizedBox();
          } else {
            return Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 11,
                minHeight: 11,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 1, left: 5, right: 5),
                child: Text(
                  "$counter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }else{
          return SizedBox();
        }
      },
    );
  }

  Stream<DocumentSnapshot> messageBodyStream(){
    return firestore
        .collection("chats")
        .document(chatId)
        .snapshots();
  }
}
