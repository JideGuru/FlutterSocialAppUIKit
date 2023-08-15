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

  Map<String, dynamic> toUpdateFirestore(String senderEmail,
      String otherNickname, String message, Owner updateTo) {
    Map<String, dynamic> conversation = {};
    conversation['message'] = message;
    conversation['otherNickname'] = otherNickname;
    conversation['read'] = updateTo == Owner.MINE ? true : false;
    conversation['senderEmail'] = senderEmail;
    conversation['time'] = Timestamp.now();

    return conversation;
  }
}

List<Chat> getChatsFromSnapshot(
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  List<Chat> chats = [];
  if (snapshot.hasData) {
    var chatsFromFirestore = snapshot.data!.data() as Map<String, dynamic>;
    print(chatsFromFirestore);
    chatsFromFirestore.forEach(
      (key, value) {
        var conversations = value as List<dynamic>;
        print(conversations.runtimeType);
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
