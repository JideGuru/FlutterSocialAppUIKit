import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app_ui/services/services.dart';

class UserService extends Services {
  setUserStatus(bool isOnline) async {
    var user = await auth.currentUser();
    if (user != null) {
      firestore
          .collection('users')
          .document(user.uid)
          .updateData({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }
}
