import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:social_app_ui/util/configs/configs.dart';

class Auth {
  Logger logger = Logger();

  Future<String> createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return consts['weak-password'].toString();
      } else if (e.code == 'email-already-in-use') {
        return consts['already-registered'].toString();
      }
    } catch (e) {
      logger.e(e);
    }
    return 'verified';
  }

  Future<String> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var verified = FirebaseAuth.instance.currentUser!.emailVerified;
      // if (!verified) {
      //   FirebaseAuth.instance.currentUser!.sendEmailVerification();
      //   return '학교 계정 인증을 완료해주세요.';
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return consts['user-not-found'].toString();
      } else if (e.code == 'wrong-password') {
        return consts['wrong-password'].toString();
      }
    } catch (e) {
      logger.e(e);
    }
    return 'verified';
  }

  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.setLanguageCode("kr");
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return consts['user-not-found'].toString();
      }
    }
    return '해당 이메일로 비밀번호 재설정 링크를 전송했습니다.';
  }

  Future<dynamic> showAuthDialog(BuildContext context, String failMessage) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(failMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, consts['close'].toString()),
              child: Text(consts['close'].toString()),
            ),
          ],
        );
      },
    );
  }
}
