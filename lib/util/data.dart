import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<Map<String, dynamic>> usersColRef =
    FirebaseFirestore.instance.collection('users-v2');

CollectionReference<Map<String, dynamic>> chatsColRef =
    FirebaseFirestore.instance.collection('chats');

CollectionReference<Map<String, dynamic>> weightsColRef =
    FirebaseFirestore.instance.collection('weights');

int toggle(int num) {
  return (num + 1) % 2;
}
