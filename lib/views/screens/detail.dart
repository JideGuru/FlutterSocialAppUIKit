import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_ui/util/animations.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/custom_button.dart';
import 'package:social_app_ui/views/widgets/custom_group_button.dart';
import 'package:social_app_ui/views/widgets/custom_sf_slider.dart';
import 'package:social_app_ui/views/widgets/custom_text_field.dart';
import 'package:social_app_ui/util/extensions.dart';

class Detail extends StatefulWidget {
  late final User user;
  Detail({
    required this.user,
  });
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  CollectionReference toFirestore =
      FirebaseFirestore.instance.collection('users');

  List<String> surveyList = List.from(essentialList)..addAll(questionList);

  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
        //essentials
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('닉네임'),
            ),
            SizedBox(height: 10.0),
            Text(widget.user.essentials['nickname']),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('성별'),
            ),
            SizedBox(height: 10.0),
            GroupButton(
              controller: GroupButtonController(
                  selectedIndex: widget.user.essentials['sex']),
              isRadio: true,
              buttons: ['남성', '여성'],
            ),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('거주 예정 생활관'),
            ),
            SizedBox(height: 10.0),
            Text(widget.user.essentials['dormitory']),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('학번'),
            ),
            SizedBox(height: 10.0),
            Text(widget.user.essentials['studentNumber']),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('단과대학'),
            ),
            SizedBox(height: 10.0),
            Text(widget.user.essentials['major']),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),

        // questions
        CustomGroupButton(
          hintText: '흡연 여부',
          surveyMode: 'smoking',
          user: widget.user,
        ).fadeInList(3, false),
        Column(
          children: [
            CustomSfSlider(
              hintText: '잠버릇',
              surveyMode: 'sleepingHabits',
              user: widget.user,
            ),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            CustomSfSlider(
              hintText: '룸메이트와 맺고 싶은 관계',
              surveyMode: 'relationship',
              user: widget.user,
            ),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            CustomSfSlider(
              hintText: '잠드는 시간을 알려주세요.',
              surveyMode: 'sleepAt',
              user: widget.user,
            ),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            CustomSfSlider(
              hintText: '방 청소 주기',
              surveyMode: 'roomCleaning',
              user: widget.user,
            ),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            CustomSfSlider(
              hintText: '화장실 청소 주기',
              surveyMode: 'restroomCleaning',
              user: widget.user,
            ),
          ],
        ).fadeInList(3, false),
        CustomGroupButton(
          hintText: '초대 선호도',
          surveyMode: 'inviting',
          user: widget.user,
        ).fadeInList(3, false),
        CustomGroupButton(
          hintText: '물건공유 선호도',
          surveyMode: 'sharing',
          user: widget.user,
        ).fadeInList(3, false),
        CustomGroupButton(
          hintText: '실내통화 선호도',
          surveyMode: 'calling',
          user: widget.user,
        ).fadeInList(3, false),
        CustomGroupButton(
          hintText: '이어폰 사용 선호도',
          surveyMode: 'earphone',
          user: widget.user,
        ).fadeInList(3, false),
        CustomGroupButton(
          hintText: '실내취식 선호도',
          surveyMode: 'eating',
          user: widget.user,
        ).fadeInList(3, false),
        CustomGroupButton(
          hintText: '늦은 스탠드 사용 선호도',
          surveyMode: 'lateStand',
          user: widget.user,
        ).fadeInList(3, false),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('룸메이트 후보들에게 추가로 전하고 싶은 말'),
            ),
            SizedBox(height: 10.0),
            CustomTextField(
              enabled: !loading,
              initialValue: widget.user.survey['etc'],
              hintText: '기타',
              textInputAction: TextInputAction.next,
              onChange: (String? val) {
                widget.user.survey['etc'] = val;
              },
            ),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
      ],
    );
  }

  buildButton() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: '저장',
            onPressed: () {
              toFirestore
                  .doc(widget.user.email)
                  .update(widget.user.toFirestore());
              print('saved');
            },
          ).fadeInList(4, false);
  }
}
