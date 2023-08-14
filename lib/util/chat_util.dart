import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'enum.dart';

class Chat {
  String email, nickname;
  List<dynamic> conversations;

  Chat({
    required this.email,
    required this.nickname,
    required this.conversations,
  });

  List<dynamic> typedToFirestore(String senderEmail, String otherNickname,
      String message, Owner updateTo) {
    List<dynamic> typedToFirestore = [];
    Map<String, dynamic> conversation = {};
    conversation['message'] = message;
    conversation['otherNickname'] = otherNickname;
    conversation['read'] = updateTo == Owner.MINE ? true : false;
    conversation['senderEmail'] = senderEmail;
    conversation['time'] = Timestamp.now();
    typedToFirestore.add(conversation);

    return typedToFirestore;
  }
}

List<Chat> getChatsFromSnapshot(
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  List<Chat> chats = [];
  if (snapshot.hasData) {
    var chatsFromFirestore = snapshot.data!.data() as Map<String, dynamic>;
    chatsFromFirestore.forEach(
      (key, value) {
        var conversations = value;
        var nickname = conversations.last['otherNickname'];
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
