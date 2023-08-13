import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Chat {
  String email, nickname;
  List<dynamic> conversations;

  Chat({
    required this.email,
    required this.nickname,
    required this.conversations,
  });
}

List<Chat> getChatsFromSnapshot(
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  List<Chat> chats = [];
  if (snapshot.hasData) {
    var chatsFromFirestore = snapshot.data!.data() as Map<String, dynamic>;
    chatsFromFirestore.forEach(
      (key, value) {
        var conversations = value;
        var nickname = conversations.last['nickname'];
        chats.add(
          Chat(
            conversations: conversations,
            nickname: nickname,
            email: key,
          ),
        );
      },
    );
  }
  return chats;
}
