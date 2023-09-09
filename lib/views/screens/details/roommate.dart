import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_ui/util/animations.dart';
import 'package:social_app_ui/util/configs/list_config.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/sort/weight.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/custom_button.dart';
import 'package:social_app_ui/views/widgets/custom_group_button.dart';
import 'package:social_app_ui/views/widgets/custom_sf_slider.dart';
import 'package:social_app_ui/util/extensions.dart';

class Roommate extends StatefulWidget {
  final String other;
  final bool authMode;
  Roommate({
    required this.other,
    required this.authMode,
  });
  @override
  _RoommateState createState() => _RoommateState();
}

class _RoommateState extends State<Roommate> {
  List<String> surveyList = questionList.sublist(0, questionList.length - 1);
  String surveyMode = 'introduction';
  int surveyIndex = 0;

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
    return FutureBuilder(
      future: usersColRef.get(),
      builder: (context, usersSnapshot) {
        if (usersSnapshot.connectionState == ConnectionState.done) {
          var other = getUserFromCollections(usersSnapshot, widget.other);
          var otherOriginal =
              getUserFromCollections(usersSnapshot, widget.other);
          return FutureBuilder(
            future: weightsColRef.get(),
            builder: (context, weightsSnapshot) {
              if (weightsSnapshot.connectionState == ConnectionState.done) {
                var domain = getDomains(weightsSnapshot);
                var weight = getWeights(weightsSnapshot, 0);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.authMode
                          ? '룸메이트에 대해 알려주세요'
                          : '${Constants.year}년도 ${Constants.semester}학기',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ).fadeInList(0, false),
                    SizedBox(height: 70.0),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: formKey,
                      child: buildForm(other),
                    ),
                    SizedBox(height: 20.0),
                    Visibility(
                      visible: widget.authMode,
                      child: buildButton(
                          context, otherOriginal, other, weight, domain),
                    ),
                    SizedBox(height: 20.0),
                  ],
                );
              } else
                return Container();
            },
          );
        } else
          return Center(
            child:
                LoadingAnimationWidget.waveDots(color: Colors.grey, size: 50),
          );
      },
    );
  }

  buildForm(User other) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //essentials
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '닉네임',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: 10.0),
            Text(other.essentials['nickname']),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '성별',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: 10.0),
            Text(sexList[other.essentials['sex']]),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '거주 생활관',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: 10.0),
            Text(other.essentials['dormitory']),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '학번',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: 10.0),
            Text(other.essentials['studentNumber']),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '단과대학',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: 10.0),
            Text(other.essentials['major']),
            SizedBox(height: 20.0),
          ],
        ).fadeInList(3, false),
        SizedBox(
          height: 40,
        ),

        // questions
        CustomGroupButton(
                hintText: '흡연 여부',
                surveyMode: 'smoking',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomSfSlider(
                hintText: '잠버릇',
                surveyMode: 'sleepingHabits',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomSfSlider(
                hintText: '룸메이트와 맺고 싶은 관계',
                surveyMode: 'relationship',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomSfSlider(
                hintText: '잠드는 시간',
                surveyMode: 'sleepAt',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomSfSlider(
                hintText: '방 청소 주기',
                surveyMode: 'roomCleaning',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomSfSlider(
                hintText: '화장실 청소 주기',
                surveyMode: 'restroomCleaning',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomGroupButton(
                hintText: '초대 선호도',
                surveyMode: 'inviting',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomGroupButton(
                hintText: '물건공유 선호도',
                surveyMode: 'sharing',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomGroupButton(
                hintText: '실내통화 선호도',
                surveyMode: 'calling',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomGroupButton(
                hintText: '이어폰 사용 선호도',
                surveyMode: 'earphone',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomGroupButton(
                hintText: '실내취식 선호도',
                surveyMode: 'eating',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
        CustomGroupButton(
                hintText: '늦은 스탠드 사용 선호도',
                surveyMode: 'lateStand',
                user: other,
                disabled: !widget.authMode)
            .fadeInList(3, false),
      ],
    );
  }

  buildButton(BuildContext context, User otherOriginal, User other,
      Map<String, dynamic> weight, Map<String, dynamic> domain) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: '제출',
            onPressed: () {
              var score = otherOriginal.getScore(other, weight, true);
              usersColRef.doc(other.email).update(
                {
                  '${Constants.year}.${Constants.semester}.other':
                      other.toFirestore(),
                },
              );
              otherOriginal.essentials['confidence'] = score['percentage'];
              usersColRef.doc(other.email).update(
                {
                  '${Constants.year}.${Constants.semester}.me':
                      otherOriginal.toFirestore(),
                },
              );
              // updateDomains(score['highest'], [], domain);
              Navigator.pop(context);
            },
            //pop up need
          ).fadeInList(4, false);
  }
}
