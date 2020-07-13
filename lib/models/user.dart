import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String email;
  String profilePicture;
  Timestamp signedUpAt;
  bool isOnline;

  User({this.name, this.email, this.profilePicture, this.signedUpAt, this.isOnline});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    signedUpAt = json['signedUpAt'];
    isOnline = json['isOnline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['profilePicture'] = this.profilePicture;
    data['signedUpAt'] = this.signedUpAt;
    data['isOnline'] = this.isOnline;
    return data;
  }
}
