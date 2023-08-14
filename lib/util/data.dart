import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<Map<String, dynamic>> usersColRef =
    FirebaseFirestore.instance.collection('users');

CollectionReference<Map<String, dynamic>> chatsColRef =
    FirebaseFirestore.instance.collection('chats');

int toggle(int num) {
  return (num + 1) % 2;
}
