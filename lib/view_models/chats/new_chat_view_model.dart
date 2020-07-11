import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NewChatViewModel extends ChangeNotifier {
  Firestore firestore = Firestore.instance;
  List<DocumentSnapshot> documents = List();
  List<DocumentSnapshot> filteredDocuments = List();
  bool loading = true;

  getDocuments() async {
    QuerySnapshot snap = await firestore
        .collection("users").getDocuments();
    List<DocumentSnapshot> docs = snap.documents;
    documents = docs;
    filteredDocuments = docs;
    loading = false;
    notifyListeners();
  }

  search(String query) {
    if(query == ""){
      filteredDocuments = documents;
    }else{
      List userSearch = documents.where((userSnap){
        Map user = userSnap.data;
        String userName = user['name'];
        return userName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredDocuments = userSearch;
    }
    notifyListeners();
  }
}