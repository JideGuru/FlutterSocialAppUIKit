import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app_ui/services/services.dart';

class UserService {
  setUserStatus(bool isOnline) {
    var user = auth.currentUser;
    if (user != null) {
      userRef
          .doc(user.uid)
          .update({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }
}
