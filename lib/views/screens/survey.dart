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
  late final bool isProfile;
  late final _SurveyState survey;
  Survey({
    required this.email,
    required this.isProfile,
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
  User user = User(
    email: '',
    essentials: {'dormitory': '창의관'},
    survey: {},
  );

  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isOtherProfile(String mode) {
    return surveyMode == mode;
  }

  nextStep() async {
    toFirestore.doc(user.email).set(user.toFirestore());

    if (surveyIndex == surveyList.length) {
      print(user.survey);
      Navigate.pushPageReplacement(context, MainScreen(email: widget.email));
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
    user.email = widget.email;
    // user.essentialInitialize();
    user.answerInitialize();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            widget.isProfile
                ? SizedBox(
                    width: 1,
                  )
                : buildLottieContainer(),
            Expanded(
              child: SingleChildScrollView(
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
          widget.isProfile
              ? (user.essentials['nickname'] == null
                  ? ''
                  : user.essentials['nickname'])
              : '설문조사',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ).fadeInList(0, false),
        SizedBox(height: 70.0),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: buildForm(widget.isProfile),
        ),
        SizedBox(height: 20.0),
        widget.isProfile
            ? CustomButton(
                label: '확인',
                onPressed: () {
                  Navigator.pop(context);
                },
              ).fadeInList(4, false)
            : buildButton(),
      ],
    );
  }

  buildForm(bool isProfile) {
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
                child: widget.isProfile
                    ? Text('')
                    : Text('룸메이트 후보들에게 나에 대해 알려주세요.'),
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
                onSaved: (String? val) {
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
          visible: widget.isProfile ? true : isOtherProfile('dormitory'),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: widget.isProfile
                    ? Text(
                        '생활관',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text('거주 예정 생활관을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              widget.isProfile
                  ? Text(user.essentials['dormitory'])
                  : DropdownButton(
                      value: user.essentials[surveyMode],
                      items: dormitoryList.map((String dorm) {
                        return DropdownMenuItem<String>(
                          child: Text('$dorm'),
                          value: dorm,
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        user.essentials[surveyMode] = value;
                        setState(() {});
                      },
                    ),
              SizedBox(height: 20.0),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('studentNumber'),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: widget.isProfile ? Text('학번') : Text('학번을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              widget.isProfile
                  ? ((user.essentials['studentNumber'] == null)
                      ? Text('입력 안함')
                      : Text(user.essentials['studentNumber']))
                  : CustomTextField(
                      enabled: !loading,
                      hintText: "학번(연도 네 자리)",
                      textInputAction: TextInputAction.next,
                      validateFunction: Validations.validateStudentNumber,
                      onSaved: (String? val) {
                        user.essentials[surveyMode] = val ?? '';
                        print(user.essentials);
                      },
                    ),
              SizedBox(height: 20.0),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('major'),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: widget.isProfile ? Text('단과대학') : Text('단과대학을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              ((user.essentials['major'] == null)
                  ? Text('입력 안함')
                  : Text(user.essentials['major'])),
              SizedBox(height: 20.0),
            ],
          ),
        ).fadeInList(3, false),

        // questions
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('smoking'),
          child: Column(
            children: [
              if (widget.isProfile)
                (CustomGroupButton(
                  hintText: '흡연',
                  surveyMode: 'smoking',
                  user: user,
                  isOhterProfile: true,
                ))
              else
                CustomGroupButton(
                  hintText: '흡연 여부를 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                  isOhterProfile: false,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('sleepingHabits'),
          child: Column(
            children: [
              if (widget.isProfile)
                (user.survey['sleepingHabits'] == null
                    ? Text('입력 없음')
                    : CustomSfSlider(
                        hintText: '잠버릇',
                        surveyMode: 'sleepingHabits',
                        user: user,
                      ))
              else
                CustomSfSlider(
                  hintText: '잠버릇을 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('relationship'),
          child: Column(
            children: [
              if (widget.isProfile)
                (user.survey['relationship'] == null
                    ? Text('입력 없음')
                    : CustomSfSlider(
                        hintText: '관계',
                        surveyMode: 'relationship',
                        user: user,
                      ))
              else
                CustomSfSlider(
                  hintText: '룸메이트와 맺고 싶은 관계를 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('sleepAt'),
          child: Column(
            children: [
              if (widget.isProfile)
                (user.survey['sleepAt'] == null
                    ? Text('입력 없음')
                    : CustomSfSlider(
                        hintText: '취침 시간',
                        surveyMode: 'sleepAt',
                        user: user,
                      ))
              else
                CustomSfSlider(
                  hintText: '잠드는 시간을 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('roomCleaning'),
          child: Column(
            children: [
              if (widget.isProfile)
                (user.survey['roomCleaning'] == null
                    ? Text('입력 없음')
                    : CustomSfSlider(
                        hintText: '방 청소 주기',
                        surveyMode: 'roomCleaning',
                        user: user,
                      ))
              else
                CustomSfSlider(
                  hintText: '방 청소 주기를 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('restroomCleaning'),
          child: Column(
            children: [
              if (widget.isProfile)
                (user.survey['restroomCleaning'] == null
                    ? Text('입력 없음')
                    : CustomSfSlider(
                        hintText: '화장실 청소 주기',
                        surveyMode: 'restroomCleaning',
                        user: user,
                      ))
              else
                CustomSfSlider(
                  hintText: '화장실 청소 주기를 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('inviting'),
          child: Column(
            children: [
              if (widget.isProfile)
                ((CustomGroupButton(
                  hintText: '친구 초대',
                  surveyMode: 'inviting',
                  user: user,
                  isOhterProfile: true,
                )))
              else
                CustomGroupButton(
                  hintText: '초대 선호도를 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                  isOhterProfile: false,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('sharing'),
          child: Column(
            children: [
              if (widget.isProfile)
                ((CustomGroupButton(
                  hintText: '물건 공유',
                  surveyMode: 'sharing',
                  user: user,
                  isOhterProfile: true,
                )))
              else
                CustomGroupButton(
                  hintText: '물건공유 선호도를 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                  isOhterProfile: false,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('calling'),
          child: Column(
            children: [
              if (widget.isProfile)
                ((CustomGroupButton(
                  hintText: '실내 통화',
                  surveyMode: 'calling',
                  user: user,
                  isOhterProfile: true,
                )))
              else
                CustomGroupButton(
                    hintText: '실내통화 선호도를 알려주세요.',
                    surveyMode: surveyMode,
                    user: user,
                    isOhterProfile: false),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('earphone'),
          child: Column(
            children: [
              if (widget.isProfile)
                ((CustomGroupButton(
                  hintText: '이어폰 사용',
                  surveyMode: 'earphone',
                  user: user,
                  isOhterProfile: true,
                )))
              else
                CustomGroupButton(
                  hintText: '이어폰 사용 선호도를 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                  isOhterProfile: false,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('eating'),
          child: Column(
            children: [
              if (widget.isProfile)
                ((CustomGroupButton(
                  hintText: '실내 취식',
                  surveyMode: 'eating',
                  user: user,
                  isOhterProfile: true,
                )))
              else
                CustomGroupButton(
                  hintText: '실내취식 선호도를 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                  isOhterProfile: false,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('lateStand'),
          child: Column(
            children: [
              if (widget.isProfile)
                (user.survey['lateStand'] == null
                    ? Text('입력 안함')
                    : (CustomGroupButton(
                        hintText: '늦은 스탠드 사용',
                        surveyMode: 'lateStand',
                        user: user,
                        isOhterProfile: true,
                      )))
              else
                CustomGroupButton(
                  hintText: '늦은 스탠드 사용 선호도를 알려주세요.',
                  surveyMode: surveyMode,
                  user: user,
                  isOhterProfile: false,
                ),
            ],
          ),
        ).fadeInList(3, false),
        Visibility(
          visible: widget.isProfile ? true : isOtherProfile('etc'),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: widget.isProfile
                    ? Text('룸메이트 후보에게 하고 싶은 말')
                    : Text('룸메이트 후보들에게 추가로 전하고 싶은 말을 알려주세요.'),
              ),
              SizedBox(height: 10.0),
              widget.isProfile
                  ? ((user.essentials['etc'] == null
                      ? Text('없음')
                      : Text(user.essentials['etc'])))
                  : CustomTextField(
                      enabled: !loading,
                      hintText: '기타',
                      textInputAction: TextInputAction.next,
                      // validateFunction: Validations.validateStudentNumber,
                      onSaved: (String? val) {
                        user.essentials[surveyMode] = val ?? '';
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
            onPressed: () => nextStep(),
          ).fadeInList(4, false);
  }
}
