import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String content;
  String senderUid;
  String type;
  Timestamp time;

  Message({this.content, this.senderUid, this.type, this.time});

  Message.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    senderUid = json['senderUid'];
    type = json['type'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['senderUid'] = this.senderUid;
    data['type'] = this.type;
    data['time'] = this.time;
    return data;
  }
}
