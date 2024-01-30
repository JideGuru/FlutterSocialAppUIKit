import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/details/detail.dart';

class OtherProfile extends StatelessWidget {
  final User other;
  OtherProfile({
    super.key,
    required this.other,
  });

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: Icon(
              Icons.report,
              color: Color.fromRGBO(0, 0, 0, 0.4),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("신고하기"),
                      actions: [
                        TextField(
                          decoration: InputDecoration(hintText: '사유를 작성해주세요.'),
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

                                var reportDoc = await FirebaseFirestore.instance
                                    .collection('report')
                                    .doc(other.email)
                                    .get();

                                var newReporter = {
                                  'report': report,
                                  'time': formattedDateTime,
                                };
                                var existingReporters = reportDoc.exists &&
                                        reportDoc.data()!.containsKey("reports")
                                    ? List.from(reportDoc["reports"])
                                    : [];
                                existingReporters.add(newReporter);
                                await FirebaseFirestore.instance
                                    .collection('report')
                                    .doc(other.email)
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
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey),
                                          child: Text(
                                            "확인",
                                            style: TextStyle(
                                                color: const Color.fromARGB(
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
                  });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Detail(
            detailMode: Owner.OTHERS,
            user: other,
          ),
        ),
      ),
    );
  }
}
