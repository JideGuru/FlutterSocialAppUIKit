import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/details/detail.dart';

class OtherProfile extends StatefulWidget {
  final MyUser other;
  final MyUser me;
  OtherProfile({
    super.key,
    required this.other,
    required this.me,
  });
  @override
  _OtherProfile createState() => _OtherProfile();
}

class _OtherProfile extends State<OtherProfile> {
  @override
  Widget build(BuildContext context) {
    bool isOther = false, isMe = false;

    List<String> meId = widget.me.email.split('@');
    blockColRef.doc(widget.other.email).get().then((value) {
      Map<String, dynamic> num = value.data() as Map<String, dynamic>;
      if (num[meId[0]] == null) {
      } else if (num[meId[0]]) {
        isMe = true;
      }
    });
    List<String> Id = widget.other.email.split('@');
    blockColRef.doc(widget.me.email).get().then((value) {
      Map<String, dynamic> num = value.data() as Map<String, dynamic>;
      if (num[Id[0]] == null) {
      } else if (num[Id[0]]) {
        isOther = true;
      }
    });
    var report = '';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          consts['details'].toString(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: isOther ? Text("차단 해제") : Text("차단하기"),
                  onTap: () {
                    setState(() {
                      if (isOther) {
                        final updates = <String, dynamic>{
                          Id[0]: FieldValue.delete(),
                        };
                        blockColRef.doc(widget.me.email).update(updates);
                      } else {
                        blockColRef
                            .doc(widget.me.email)
                            .update({(Id[0]): true});
                      }
                    });
                  }),
              PopupMenuItem(
                  child: Text("신고하기"),
                  onTap: () {
                    print('debug');
                    Future<void>.delayed(
                      Duration.zero,
                      () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("신고하기"),
                              actions: [
                                TextField(
                                  decoration:
                                      InputDecoration(hintText: '사유를 작성해주세요.'),
                                  onChanged: (value) {
                                    report = value;
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: Text(
                                        "신고",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        String _formatTime(DateTime dateTime) {
                                          String period =
                                              dateTime.hour < 12 ? '오전' : '오후';
                                          int hour = dateTime.hour % 12 == 0
                                              ? 12
                                              : dateTime.hour % 12;
                                          String minute = dateTime.minute
                                              .toString()
                                              .padLeft(2, '0');
                                          String second = dateTime.second
                                              .toString()
                                              .padLeft(2, '0');
                                          return '$period $hour시 $minute분 $second초';
                                        }

                                        DateTime now = DateTime.now();
                                        String formattedDateTime =
                                            "${now.year}년 ${now.month}월 ${now.day}일 ${_formatTime(now)}";
                                        print(formattedDateTime);

                                        var reportDoc = await FirebaseFirestore
                                            .instance
                                            .collection('report')
                                            .doc(widget.other.email)
                                            .get();

                                        var newReporter = {
                                          'report': report,
                                          'time': formattedDateTime,
                                        };
                                        var existingReporters = reportDoc
                                                    .exists &&
                                                reportDoc
                                                    .data()!
                                                    .containsKey("reports")
                                            ? List.from(reportDoc["reports"])
                                            : [];
                                        existingReporters.add(newReporter);
                                        await FirebaseFirestore.instance
                                            .collection('report')
                                            .doc(widget.other.email)
                                            .set(
                                          {
                                            'reports': existingReporters,
                                          },
                                        );
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text("신고되었습니다."),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.grey),
                                                  child: Text(
                                                    "확인",
                                                    style: TextStyle(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 91, 91, 91)),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey),
                                        child: Text(
                                          "취소",
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 91, 91, 91)),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                ),
                              ],
                            );
                          }),
                    );
                  })
            ];
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Detail(
            detailMode: Owner.OTHERS,
            user: widget.other,
          ),
        ),
      ),
    );
  }
}
