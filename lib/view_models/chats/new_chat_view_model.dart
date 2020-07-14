import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NewChatViewModel extends ChangeNotifier {
  Firestore firestore = Firestore.instance;
  List<DocumentSnapshot> users = List();
  List<DocumentSnapshot> filteredUsers = List();
  bool loading = true;

  getUsers() async {
    QuerySnapshot snap = await firestore
        .collection("users").getDocuments();
    List<DocumentSnapshot> docs = snap.documents;
    users = docs;
    filteredUsers = docs;
    loading = false;
    notifyListeners();
  }

  search(String query) {
    if(query == ""){
      filteredUsers = users;
    }else{
      List userSearch = users.where((userSnap){
        Map user = userSnap.data;
        String userName = user['name'];
        return userName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredUsers = userSearch;
    }
    notifyListeners();
  }

  removeFromList(index) {
    filteredUsers.removeAt(index);
    notifyListeners();
  }
}
