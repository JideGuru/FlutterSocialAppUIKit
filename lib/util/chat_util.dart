import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

void getChats(String email) {
  FirebaseFirestore.instance
      .collection('chats')
      .doc(email)
      .get()
      .then((value) => print(value));
//   .collection("chats")
// .where("", "array-contains", "myEmail-")
}

class Chat {
  String email, nickname;
  List<dynamic> conversations;

  Chat({
    required this.email,
    required this.nickname,
    required this.conversations,
  });
}

// class Conversation {
//   Map<String, dynamic> data;

//   Conversation({
//     required this.data,
//   });

//   static List<Map<String, dynamic>> getConversations(
//       dynamic conversationsFromFirestore) {
//     List<Map<String, dynamic>> conversations = [];
//     for (var conversation in conversationsFromFirestore as List<dynamic>) {
//       conversations.add(
//         Conversation(data: conversation),
//       );
//     }
//     return conversations;
//   }
// }

List<Chat> getChatsFromSnapshot(
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  List<Chat> chats = [];
  if (snapshot.hasData) {
    var chatsFromFirestore = snapshot.data!.data() as Map<String, dynamic>;
    chatsFromFirestore.forEach(
      (key, value) {
        var conversations = value;
        var nickname = conversations.last['nickname'];
        print("nickname: $nickname");
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
