import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<Map<String, dynamic>> usersColRef =
    FirebaseFirestore.instance.collection('users-v0');

CollectionReference<Map<String, dynamic>> chatsColRef =
    FirebaseFirestore.instance.collection('chats-v0');

CollectionReference<Map<String, dynamic>> weightsColRef =
    FirebaseFirestore.instance.collection('weights');

DocumentReference<Map<String, dynamic>> constsDocRef =
    FirebaseFirestore.instance.collection('constants').doc('constants');

CollectionReference<Map<String, dynamic>> evalsColRef =
    FirebaseFirestore.instance.collection('roommateEvals');
