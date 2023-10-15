import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/user.dart';

class Notify {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future<void> updateToken({
    required String email,
  }) async {
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.getToken().then(
      (token) {
        if (token != null) {
          print(token);
          usersColRef.doc(email).update(
            {
              'token': token,
            },
          );
        }
      },
    );
  }

  static Future<void> notify({
    required User from,
    required User to,
    required String message,
  }) async {
    try {
      final msg = {
        'to': to.essentials['token'],
        'notification': {
          'title': to.essentials['nickname'],
          'body': message,
        },
      };
      post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAAlTydX30:APA91bH5vYC6SJ39hlw57MAWQZXqrS58UH3TLi2yYJw4qwR-K-ipCyeHoqbM6n5f78jkU1u_iC22ewYTvGsnGVXQY-ekYMCN5whKjyD9JZY1uLMSaCXatxfw8nuJ3MpmPAFFPnH5T2Db',
        },
        body: jsonEncode(msg),
      );
    } catch (e) {
      print(e);
    }
  }
}
