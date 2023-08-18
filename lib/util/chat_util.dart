import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Chat {
  String email;
  List<dynamic> conversations;

  Chat({
    required this.email,
    required this.conversations,
  });

  Map<String, dynamic> toUpdateFirestore() {
    return {email: conversations};
  }
}

List<Chat> getChatsFromSnapshot(
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  List<Chat> chats = [];
  if (snapshot.hasData) {
    var chatsFromFirestore = snapshot.data!.data() as Map<String, dynamic>;
    chatsFromFirestore.forEach(
      (key, value) {
        var conversations = value as List<dynamic>;
        chats.add(
          Chat(
            conversations: conversations,
            email: key,
          ),
        );
      },
    );
  }
  return chats;
}

Chat getChatFromSnapshot(String email,
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  Chat chat = Chat(email: email, conversations: []);
  if (snapshot.hasData) {
    var data = snapshot.data!.data() as Map<String, dynamic>;
    chat.conversations = data[email];
  }
  return chat;
}
