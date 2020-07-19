import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/components/chat_item.dart';
import 'package:social_app_ui/models/message.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/view_models/user/user_view_model.dart';
import 'package:social_app_ui/views/chat/new_chat/new_chat.dart';

class Chats extends StatelessWidget {
  final Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel =
        Provider.of<UserViewModel>(context, listen: false);
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
      body: StreamBuilder(
        stream: userChatsStream('${viewModel.user.uid}'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List chatList = snapshot.data.documents;
            if(chatList.isNotEmpty){
              return ListView.separated(
                itemCount: chatList.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot chatListSnapshot = chatList[index];
                  return StreamBuilder(
                      stream: messageListStream(chatListSnapshot.documentID),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List messages = snapshot.data.documents;
                          Message message = Message.fromJson(messages.first.data);
                          List users = chatListSnapshot.data['users'];
                          // remove the current user's id from the Users
                          // list so we can get the second user's id
                          users.remove('${viewModel.user.uid}');
                          String recipient = users[0];
                          return ChatItem(
                            userId: recipient,
                            messageCount: messages.length,
                            msg: message.content,
                            time: message.time,
                            chatId: chatListSnapshot.documentID,
                            type: message.type,
                            currentUserId: viewModel.user.uid,
                          );
                        }else{
                          return SizedBox();
                        }
                      }
                  );
                },
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
              );
            }else{
              return Center(child: Text('No chats yet'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Feather.edit_2,
          color: Colors.white,
        ),
        onPressed: () => Router.pushPageDialog(context, NewChat()),
      ),
    );
  }

  Stream<QuerySnapshot> userChatsStream(String uid){
    return firestore
        .collection('chats')
        .where('users', arrayContains: '$uid')
        .snapshots();
  }

  Stream<QuerySnapshot> messageListStream(String documentId){
    return firestore
        .collection("chats")
        .document(documentId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
  }
}
