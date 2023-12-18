import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:getwidget/getwidget.dart';

class Settings extends StatefulWidget {
  User user;
  Settings({
    super.key,
    required this.user,
  });
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          consts['setting'].toString(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Container(
            decoration:
                BoxDecoration(color: Color.fromRGBO(245, 245, 245, 0.95)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Image.asset(
                    'assets/images/language.png',
                    height: 35,
                    width: 35,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 95.0),
                  child: Text(consts['language'].toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          fontFamily: GoogleFonts.inter().fontFamily)),
                ),
                GroupButton(
                  options: GroupButtonOptions(
                    borderRadius: BorderRadius.circular(5.0),
                    selectedColor: Color.fromRGBO(12, 73, 127, 1.0),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    unselectedColor: Colors.black,
                    unselectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  controller: GroupButtonController(
                    selectedIndex: widget.user.essentials['language'],
                  ),
                  onSelected: (value, index, isSelected) {
                    widget.user.essentials['language'] = index;
                    usersColRef.doc(widget.user.email).update(
                        {'language': widget.user.essentials['language']});
                    showToast(
                      consts['saved'].toString(),
                      context: context,
                      animation: StyledToastAnimation.fade,
                    );
                  },
                  buttons: ["KOR", "ENG"],
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(245, 245, 245, 0.95)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Image.asset(
                        'assets/images/bell.png',
                        height: 35,
                        width: 35,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 150.0),
                      child: Text(consts['notification'].toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                              fontFamily: GoogleFonts.inter().fontFamily)),
                    ),
                    GFToggle(
                      onChanged: (val) {
                        if (val == true)
                          widget.user.essentials['notification'] = 1;
                        else
                          widget.user.essentials['notification'] = 0;
                        usersColRef.doc(widget.user.email).update({
                          'notification': widget.user.essentials['notification']
                        });
                        showToast(
                          consts['saved'].toString(),
                          context: context,
                          animation: StyledToastAnimation.fade,
                        );
                      },
                      value: true,
                      enabledThumbColor: Color.fromRGBO(255, 255, 255, 1.0),
                      enabledTrackColor: Color.fromRGBO(21, 115, 254, 1.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
