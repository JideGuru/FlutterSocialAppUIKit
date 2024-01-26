import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app_ui/views/screens/survey.dart';

class TermsAndPrivacy extends StatefulWidget {
  final String email;

  TermsAndPrivacy({Key? key, required this.email}) : super(key: key);

  @override
  _TermsAndPrivacyState createState() => _TermsAndPrivacyState();
}

class _TermsAndPrivacyState extends State<TermsAndPrivacy> {
  bool agreeTerms = false;
  bool agreePrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("이용약관 및 개인정보 처리방침")),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "서비스 이용약관",
                style: GoogleFonts.atkinsonHyperlegible(
                    fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "1. 서비스의 목적",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "서비스의 목적은 사용자에게 편리한 룸메이트 찾기 서비스를 제공합니다.",
              ),
            ),
            Text(
              "2. 이용자의 의무",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "이용자는 서비스를 이용함에 있어 다음 사항을 준수해야 합니다.\n   - 서비스에 제공한 정보의 정확성 유지\n   - 다른 이용자에게 피해를 주지 않는 행동",
              ),
            ),
            Text(
              "3. 서비스 이용 제한",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "서비스 이용 시 다음 사항에 해당하는 경우 서비스 이용이 제한될 수 있습니다.\n   - 불법적인 목적으로 서비스 이용\n   - 타인의 정보를 부정하게 사용하는 행위",
              ),
            ),
            Text(
              "4. 서비스 변경 및 중단",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "본 서비스는 운영상 또는 기술적인 필요에 따라 제공되는 일부 또는 전부를 수정, 중단할 수 있습니다.",
              ),
            ),
            Text(
              "5. 소유권 및 지적 재산",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "본 서비스에 포함된 모든 콘텐츠 및 자료의 지적 재산권은 해당 콘텐츠 또는 자료를 제공한 자에게 귀속됩니다.",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("이용약관에 동의합니다."),
                Checkbox(
                  value: agreeTerms,
                  onChanged: (value) {
                    setState(() {
                      agreeTerms = value!;
                    });
                  },
                ),
              ],
            ),
            Divider(),
            Center(
              child: Text(
                "개인정보 처리방침",
                style: GoogleFonts.atkinsonHyperlegible(
                    fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "1. 수집하는 개인정보 항목",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "서비스 이용과 관련하여 수집하는 개인정보 항목은 다음과 같습니다.\n   - 이용자의 식별 정보 (이메일 등)\n   - 서비스 이용 기록",
              ),
            ),
            Text(
              "2. 개인정보의 수집 및 이용목적",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "수집한 개인정보는 다음 목적으로 이용됩니다.\n   - 서비스 제공, 유지, 개선\n   - 고객 지원 및 문의 응답\n   - 서비스 이용 통계 및 분석",
              ),
            ),
            Text(
              "3. 개인정보의 제3자 제공",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "개인정보는 본인의 동의 없이 제3자에게 제공되지 않습니다. 다만, 관련 법령에 의해 요구되는 경우가 있습니다.",
              ),
            ),
            Text(
              "4. 개인정보의 보유 및 파기",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "서비스 이용 중 수집된 개인정보는 10년 후에는 지체 없이 파기됩니다.",
              ),
            ),
            Text(
              "5. 개인정보 보호책임자",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "서비스 이용과 관련된 개인정보 보호 및 관리에 대한 문의사항은 개인정보 보호책임자에게 문의하시기 바랍니다.",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("개인정보 처리방침에 동의합니다."),
                Checkbox(
                  value: agreePrivacy,
                  onChanged: (value) {
                    setState(() {
                      agreePrivacy = value!;
                    });
                  },
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            String message = "";

            if (!agreeTerms && !agreePrivacy) {
              message = "이용약관과 개인정보 처리방침에 모두 동의해야 합니다.";
            } else if (!agreeTerms) {
              message = "이용약관에 동의해야 합니다.";
            } else if (!agreePrivacy) {
              message = "개인정보 처리방침에 동의해야 합니다.";
            }

            if (message.isNotEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(message, style: TextStyle(fontSize: 20.0)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("확인"),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Survey(email: widget.email),
                ),
              );
            }
          },
          child: Text('완료'),
        ),
      ),
    );
  }
}
