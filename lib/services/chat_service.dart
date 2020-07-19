import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app_ui/models/message.dart';
import 'package:social_app_ui/services/services.dart';

class ChatService extends Services {
  FirebaseStorage storage = FirebaseStorage.instance;

  sendMessage(Message message, String chatId) async {
    await firestore
        .collection("chats")
        .document("$chatId")
        .collection("messages")
        .add(message.toJson());

    await firestore
        .collection("chats")
        .document("$chatId")
        .updateData({"lastTextTime": Timestamp.now()});
  }

  Future<String> sendFirstMessage(Message message, String recipient) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = await firestore.collection("chats").add({
      'users': [recipient, user.uid],
    });
    await sendMessage(message, ref.documentID);
    return ref.documentID;
  }

  Future<String> uploadImage(File image, String chatId) async {
    StorageReference storageReference =
        storage.ref().child("chats").child(chatId).child(uuid.v4());

    StorageUploadTask uploadTask = storageReference.putFile(image);
    String imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    return imageUrl;
  }

  setUserRead(String chatId, FirebaseUser user, int count) async {
    DocumentSnapshot snap =
        await firestore.collection("chats").document(chatId).get();
    Map reads = snap.data['reads'];
    reads[user.uid] = count;
    await firestore
        .collection("chats")
        .document(chatId)
        .updateData({'reads': reads});
  }

  setUserTyping(String chatId, FirebaseUser user, bool userTyping) async {
    DocumentSnapshot snap =
        await firestore.collection("chats").document(chatId).get();
    Map typing = snap.data['typing'] ?? {};
    typing[user.uid] = userTyping;
    await firestore.collection("chats").document(chatId).updateData({
      'typing': typing,
    });
  }
}
