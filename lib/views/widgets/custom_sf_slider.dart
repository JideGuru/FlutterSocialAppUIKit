// import 'package:flutter/material.dart';
// import 'package:social_app_ui/util/configs/configs.dart';
// import 'package:social_app_ui/util/extensions.dart';
// import 'package:social_app_ui/util/configs/list_config.dart';
// import 'package:social_app_ui/util/user.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';

// class CustomSfSlider extends StatefulWidget {
//   late final String sliderKey;
//   late final User user;
//   final String userMode;
//   CustomSfSlider({
//     super.key,
//     required this.sliderKey,
//     required this.user,
//     this.userMode = '',
//   });

//   @override
//   State<CustomSfSlider> createState() => _CustomSfSliderState();
// }

// class _CustomSfSliderState extends State<CustomSfSlider> {
//   @override
//   Widget build(BuildContext context) {
//     double labelSize = 8;
//     if (answerList[widget.surveyMode]!.length > 5) labelSize = 4;
//     var surveyCheck = widget.user.survey.containsKey(widget.surveyMode);
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Column(
//             children: [
//               Text(
//                 surveyHintTexts[widget.sliderKey]!,
//                 style: Theme.of(context).textTheme.labelMedium,
//               ),
//               SizedBox(height: 20.0),
//             ],
//           ),
//         ),
//         surveyCheck
//             ? SfSliderTheme(
//                 data: SfSliderThemeData(
//                   disabledThumbColor: widget.userMode == 'roommate'
//                       ? Color.fromARGB(255, 157, 157, 143)
//                       : null,
//                   disabledInactiveTrackColor: widget.userMode == 'roommate'
//                       ? Color.fromARGB(255, 186, 186, 143).withOpacity(0.5)
//                       : null,
//                   disabledActiveTrackColor: widget.userMode == 'roommate'
//                       ? Color.fromARGB(255, 186, 186, 143)
//                       : null,
//                   thumbColor: widget.userMode == 'roommate'
//                       ? Color.fromARGB(255, 199, 199, 60)
//                       : null,
//                   inactiveTrackColor: widget.userMode == 'roommate'
//                       ? Color.fromARGB(255, 199, 199, 60).withOpacity(0.5)
//                       : null,
//                   activeTrackColor: widget.userMode == 'roommate'
//                       ? Color.fromARGB(255, 199, 199, 60)
//                       : null,
//                   activeLabelStyle:
//                       TextStyle(fontSize: labelSize, color: Colors.black),
//                   inactiveLabelStyle:
//                       TextStyle(fontSize: labelSize, color: Colors.black),
//                 ),
//                 child: SfSlider(
//                   value: widget.user.survey[widget.surveyMode],
//                   min: 0,
//                   max: answerList[widget.surveyMode]!.length - 1,
//                   interval: 1,
//                   showTicks: true,
//                   showLabels: true,
//                   labelFormatterCallback: (actualValue, formattedText) {
//                     switch (actualValue) {
//                       case 0:
//                         return answerList[widget.surveyMode]![0];
//                       case 1:
//                         return answerList[widget.surveyMode]![1];
//                       case 2:
//                         return answerList[widget.surveyMode]![2];
//                       case 3:
//                         return answerList[widget.surveyMode]![3];
//                       case 4:
//                         return answerList[widget.surveyMode]![4];
//                       case 5:
//                         return answerList[widget.surveyMode]![5];
//                       case 6:
//                         return answerList[widget.surveyMode]![6];
//                     }
//                     return actualValue.toString();
//                   },
//                   onChanged: widget.disabled
//                       ? null
//                       : (value) {
//                           widget.user.survey[widget.surveyMode] = value.round();
//                           mounted ? setState(() {}) : dispose();
//                         },
//                 ),
//               )
//             : SizedBox(),
//         Visibility(
//           visible: widget.hintText != '',
//           child: SizedBox(height: 10),
//         )
//       ],
//     ).fadeInList(3, false);
//   }
// }
