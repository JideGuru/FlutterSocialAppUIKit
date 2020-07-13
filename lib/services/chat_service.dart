import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app_ui/models/message.dart';
import 'package:social_app_ui/services/services.dart';

class ChatService extends Services {
  sendMessage(Message message, String id) async {
    await firestore
        .collection("chats")
        .document("$id")
        .collection("messages")
        .add(message.toJson());
  }

  Future<String> sendFirstMessage(Message message, String recipient) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = await firestore.collection("chats").add({
      'users': [recipient, user.uid],
    });
    await sendMessage(message, ref.documentID);
    return ref.documentID;
  }
}
