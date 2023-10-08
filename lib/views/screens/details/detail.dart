import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_ui/util/animations.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/configs/list_config.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/widgets/custom_button.dart';
import 'package:social_app_ui/views/widgets/custom_group_button.dart';
import 'package:social_app_ui/views/widgets/custom_sf_slider.dart';
import 'package:social_app_ui/views/widgets/custom_text_field.dart';
import 'package:social_app_ui/util/extensions.dart';

class Detail extends StatefulWidget {
  late final User user, meanRoommate;
  late final String userMode;
  final Owner detailMode;
  Detail({
    required this.user,
    required this.meanRoommate,
    this.userMode = 'own',
    this.detailMode = Owner.OTHERS,
  });
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
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
    return Container(
      child: Row(
        children: [
          buildLottieContainer(),
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: buildFormContainer(),
                ),
              ),
            ),
          ),
        ],
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
        SizedBox(
          height: MediaQuery.of(context).size.height / 15,
        ),
        Text('${Constants.year}년도 ${Constants.semester}학기',
                style: Theme.of(context).textTheme.headlineLarge)
            .fadeInList(0, false),
        SizedBox(height: 70.0),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: buildForm(),
        ),
        SizedBox(height: 20.0),
        if (widget.detailMode != Owner.OTHERS) buildButton(),
        SizedBox(height: 20.0),
      ],
    );
  }

  buildForm() {
    var surveyCheck = widget.user.survey.length;
    return surveyCheck > 0
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //essentials
              widget.userMode == 'own'
                  ? Column(
                      children: [
                        Essential('닉네임', 'nickname').fadeInList(3, false),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '성별',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(sexList[widget.user.essentials['sex']]),
                            SizedBox(height: 20.0),
                          ],
                        ).fadeInList(3, false),
                        Essential('거주 예정 생활관', 'dormitory')
                            .fadeInList(3, false),
                        Essential('학번', 'studentNumber').fadeInList(3, false),
                        Essential('단과대학', 'major').fadeInList(3, false),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    )
                  : SizedBox(),

              // questions
              CustomGroupButtons('흡연여부', 'smoking'),

              CustomSfSliders('잠버릇', 'sleepingHabits'),
              CustomSfSliders('관계', 'relationship'),
              CustomSfSliders('취침시간', 'sleepAt'),
              CustomSfSliders('방 청소', 'roomCleaning'),
              CustomSfSliders('화장실 청소', 'restroomCleaning'),

              CustomGroupButtons('초대', 'inviting'),
              CustomGroupButtons('물건공유', 'sharing'),
              CustomGroupButtons('통화', 'calling'),
              CustomGroupButtons('이어폰', 'earphone'),
              CustomGroupButtons('취식', 'eating'),
              CustomGroupButtons('늦은 스탠드 사용', 'lateStand'),

              widget.userMode == 'own'
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '룸메이트 후보들에게 추가로 전하고 싶은 말',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        CustomTextField(
                          enabled: widget.detailMode == Owner.OTHERS
                              ? false
                              : !loading,
                          initialValue: widget.user.survey['etc'],
                          hintText: '기타',
                          textInputAction: TextInputAction.next,
                          onChange: (String? val) {
                            widget.user.survey['etc'] = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ).fadeInList(3, false)
                  : SizedBox(),
            ],
          )
        : Center(
            child: Text('이전 룸메이트들의 설문이 존재하지 않음'),
          );
  }

  Column Essential(String label, String key) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        SizedBox(height: 10.0),
        Text(widget.user.essentials[key]),
        SizedBox(height: 20.0),
      ],
    );
  }

  Column CustomSfSliders(hintText, String surveyMode) {
    return Column(
      children: [
        CustomSfSlider(
          disabled: widget.detailMode == Owner.OTHERS || Constants.auth,
          hintText: hintText,
          surveyMode: surveyMode,
          user: widget.user,
        ).fadeInList(3, false),
        Visibility(
          visible: widget.meanRoommate.survey.containsKey(surveyMode),
          child: CustomSfSlider(
            disabled: true,
            surveyMode: surveyMode,
            user: widget.meanRoommate,
            userMode: 'roommate',
          ).fadeInList(3, false),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Column CustomGroupButtons(String hintText, String surveyMode) {
    return Column(
      children: [
        CustomGroupButton(
          disabled: widget.detailMode == Owner.OTHERS || Constants.auth,
          hintText: hintText,
          surveyMode: surveyMode,
          user: widget.user,
        ).fadeInList(3, false),
        Visibility(
          visible: widget.meanRoommate.survey.containsKey(surveyMode),
          child: CustomGroupButton(
            disabled: true,
            surveyMode: surveyMode,
            user: widget.meanRoommate,
            userMode: 'roommate',
          ).fadeInList(3, false),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  buildButton() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Visibility(
            visible: !Constants.auth,
            child: CustomButton(
              label: '저장',
              onPressed: () {
                usersColRef.doc(widget.user.email).update(
                  {
                    '${Constants.year}.${Constants.semester}.me':
                        widget.user.toFirestore()
                  },
                );
              },
              //pop up need
            ),
          ).fadeInList(4, false);
  }
}
