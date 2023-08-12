import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_ui/util/animations.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/util/validations.dart';
import 'package:social_app_ui/views/widgets/custom_button.dart';
import 'package:social_app_ui/views/widgets/custom_group_button.dart';
import 'package:social_app_ui/views/widgets/custom_sf_slider.dart';
import 'package:social_app_ui/views/widgets/custom_text_field.dart';
import 'package:social_app_ui/util/extensions.dart';

import 'main_screen.dart';

class Survey extends StatefulWidget {
  late final String email;
  Survey({
    required this.email,
  });
  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  CollectionReference toFirestore =
      FirebaseFirestore.instance.collection('users');

  List<String> surveyList = List.from(essentialList)..addAll(questionList);
  String surveyMode = 'introduction';
  int surveyIndex = 0;

  late User user;

  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  nextStep() async {
    if (surveyIndex == surveyList.length) {
      Navigate.pushPageReplacement(context, MainScreen(email: user.email));
    }

    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
    } else {
      surveyMode = surveyList[surveyIndex++];
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    user = User.init(widget.email);
    toFirestore.doc(user.email).set(user.toFirestore());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            buildLottieContainer(),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: buildFormContainer(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildLottieContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      width: screenWidth < 700 ? 0 : screenWidth * 0.5,
      duration: Duration(milliseconds: 500),
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      child: Center(
        child: Lottie.asset(
          AppAnimations.chatAnimation,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  buildFormContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '설문조사',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ).fadeInList(0, false),
        SizedBox(height: 70.0),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: buildForm(),
        ),
        SizedBox(height: 20.0),
        buildButton(),
      ],
    );
  }

  buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: surveyMode == 'introduction',
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: Text('룸메이트 후보들에게 나에 대해 알려주세요.'),
              ),
            ],
          ),
        ).fadeInList(3, false),

        //essentials
        Visibility(
          visible: surveyMode == 'nickname',
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('닉네임을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                enabled: !loading,
                hintText: "닉네임",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateNickname,
                onChange: (String? val) {
                  user.essentials[surveyMode] = val ?? '';
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'sex',
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('성별을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              GroupButton(
                isRadio: true,
                buttons: ['남성', '여성'],
                onSelected: (value, index, isSelected) {
                  user.survey[surveyMode] = index;
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'dormitory',
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('거주 예정 생활관을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              DropdownButton(
                // value: user.essentials[surveyMode],
                items: dormitoryList.map((String dorm) {
                  return DropdownMenuItem<String>(
                    child: Text('$dorm'),
                    value: dorm,
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  user.essentials[surveyMode] = value;
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'studentNumber',
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('학번을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                enabled: !loading,
                hintText: "학번(연도 네 자리)",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateStudentNumber,
                onChange: (String? val) {
                  user.essentials[surveyMode] = val;
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'major',
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('단과대학을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                enabled: !loading,
                hintText: "단과대학",
                textInputAction: TextInputAction.next,
                onChange: (String? val) {
                  user.essentials[surveyMode] = val ?? '';
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ).fadeInList(3, false),

        // questions
        Visibility(
          visible: surveyMode == 'smoking',
          child: CustomGroupButton(
            hintText: '흡연 여부를 알려주세요.',
            surveyMode: surveyMode,
            user: user,
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'sleepingHabits',
          child: Column(
            children: [
              CustomSfSlider(
                hintText: '잠버릇을 알려주세요.',
                surveyMode: surveyMode,
                user: user,
              ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'relationship',
          child: Column(
            children: [
              CustomSfSlider(
                hintText: '룸메이트와 맺고 싶은 관계를 알려주세요.',
                surveyMode: surveyMode,
                user: user,
              ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'sleepAt',
          child: Column(
            children: [
              CustomSfSlider(
                hintText: '잠드는 시간을 알려주세요.',
                surveyMode: surveyMode,
                user: user,
              ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'roomCleaning',
          child: Column(
            children: [
              CustomSfSlider(
                hintText: '방 청소 주기를 알려주세요.',
                surveyMode: surveyMode,
                user: user,
              ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'restroomCleaning',
          child: Column(
            children: [
              CustomSfSlider(
                hintText: '화장실 청소 주기를 알려주세요.',
                surveyMode: surveyMode,
                user: user,
              ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'inviting',
          child: CustomGroupButton(
            hintText: '초대 선호도를 알려주세요.',
            surveyMode: surveyMode,
            user: user,
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'sharing',
          child: CustomGroupButton(
            hintText: '물건공유 선호도를 알려주세요.',
            surveyMode: surveyMode,
            user: user,
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'calling',
          child: CustomGroupButton(
            hintText: '실내통화 선호도를 알려주세요.',
            surveyMode: surveyMode,
            user: user,
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'earphone',
          child: CustomGroupButton(
            hintText: '이어폰 사용 선호도를 알려주세요.',
            surveyMode: surveyMode,
            user: user,
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'eating',
          child: CustomGroupButton(
            hintText: '실내취식 선호도를 알려주세요.',
            surveyMode: surveyMode,
            user: user,
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'lateStand',
          child: CustomGroupButton(
            hintText: '늦은 스탠드 사용 선호도를 알려주세요.',
            surveyMode: surveyMode,
            user: user,
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: surveyMode == 'etc',
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('룸메이트 후보들에게 추가로 전하고 싶은 말을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                enabled: !loading,
                hintText: '기타',
                textInputAction: TextInputAction.next,
                onChange: (String? val) {
                  user.survey[surveyMode] = val ?? '';
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ).fadeInList(3, false),
      ],
    );
  }

  buildButton() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: '다음',
            onPressed: () {
              toFirestore.doc(user.email).update(user.toFirestore());
              nextStep();
            }).fadeInList(4, false);
  }
}
