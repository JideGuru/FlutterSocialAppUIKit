import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app_ui/models/message.dart';
import 'package:social_app_ui/services/services.dart';

class ChatService {
  FirebaseStorage storage = FirebaseStorage.instance;

  sendMessage(Message message, String chatId) async {
    await chatRef
        .doc("$chatId")
        .collection("messages")
        .add(message.toJson());

    await chatRef
        .doc("$chatId")
        .update({"lastTextTime": Timestamp.now()});
  }

  Future<String> sendFirstMessage(Message message, String recipient) async {
    User user = auth.currentUser;
    DocumentReference ref = await chatRef.add({
      'users': [recipient, user.uid],
    });
    await sendMessage(message, ref.id);
    return ref.id;
  }

  Future<String> uploadImage(File image, String chatId) async {
    StorageReference storageReference =
        storage.ref().child("chats").child(chatId).child(uuid.v4());

    StorageUploadTask uploadTask = storageReference.putFile(image);
    String imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    return imageUrl;
  }

  setUserRead(String chatId, User user, int count) async {
    DocumentSnapshot snap = await chatRef.doc(chatId).get();
    Map reads = snap.data()['reads']??{};
    reads[user.uid] = count;
    await chatRef
        .doc(chatId)
        .update({'reads': reads});
  }

  setUserTyping(String chatId, User user, bool userTyping) async {
    DocumentSnapshot snap = await chatRef.doc(chatId).get();
    Map typing = snap.data()['typing'] ?? {};
    typing[user.uid] = userTyping;
    await chatRef.doc(chatId).update({
      'typing': typing,
    });
  }
}
