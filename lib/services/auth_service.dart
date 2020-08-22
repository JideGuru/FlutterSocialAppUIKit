import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app_ui/services/services.dart';
import 'package:social_app_ui/util/const.dart';

class AuthService extends Services {
  /// Search our [FirebaseFirestore] database to see if the user email exists
  Future<bool> checkUser(String email) async {
    QuerySnapshot snap = await userRef
        .where("email", isEqualTo: email)
        .get();

    if (snap.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /// Register user with [FirebaseAuth] then store the user details
  /// on our [FirebaseFirestore] database
  Future<bool> registerUser({String email, password, name}) async {
    // Create user with [FirebaseAuth]
    var res = await auth.createUserWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );

    if (res.user != null) {
      // After registration is successful, store user details to [FirebaseFirestore].
      User user = res.user;
      await userRef.doc("${user.uid}").set({
        "email": user.email,
        "name": name,
        "signedUpAt": Timestamp.now(),
        "profilePicture": Constants.defaultPicture,
      });
      return true;
    } else {
      return false;
    }
  }

  /// Login using [FirebaseAuth]
  Future<bool> loginUser({String email, String password}) async {
    var res = await auth.signInWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );

    if (res.user != null) {
      return true;
    } else {
      return false;
    }
  }

  logOut() async {
    print("logout");
    await auth.signOut();
  }

  String handleFirebaseAuthError(String e) {
    if (e.contains("ERROR_WEAK_PASSWORD")) {
      return "Password is too weak";
    } else if (e.contains("ERROR_INVALID_EMAIL")) {
      return "Invalid Email";
    } else if (e.contains("ERROR_EMAIL_ALREADY_IN_USE")) {
      return "The email address is already in use by another account.";
    } else if (e.contains("ERROR_NETWORK_REQUEST_FAILED")) {
      return "Network error occurred!";
    } else if (e.contains("ERROR_USER_NOT_FOUND")) {
      return "Invalid credentials.";
    } else if (e.contains("ERROR_WRONG_PASSWORD")) {
      return "Invalid credentials.";
    } else {
      return e;
    }
  }
}
