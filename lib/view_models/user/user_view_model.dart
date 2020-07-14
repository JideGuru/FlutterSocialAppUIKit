import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserViewModel extends ChangeNotifier {
  FirebaseUser user;
  FirebaseAuth auth = FirebaseAuth.instance;

  setUser() async {
    user = await auth.currentUser();
    notifyListeners();
  }
}
