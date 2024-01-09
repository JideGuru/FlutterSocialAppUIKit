import 'package:flutter/material.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/chat/chats.dart';
import 'package:social_app_ui/views/screens/home.dart';
import 'package:social_app_ui/views/screens/my_profile.dart';

class MainScreen extends StatefulWidget {
  late final User me;
  MainScreen({
    super.key,
    required this.me,
  });
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    int status = widget.me.essentials['status'];
    bool homeFlag = status == 0;
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          if (homeFlag) Home(me: widget.me),
          MyProfile(
            me: widget.me,
            onStatusChanged: onStatusChagned,
          ),
          Chats(me: widget.me),
          // Settings(user: widget.me),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          if (homeFlag)
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: consts['home'].toString(),
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: consts['my-profile'].toString(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: consts['chat'].toString(),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: consts['setting'].toString(),
          // ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onStatusChagned(int index) {
    mounted
        ? setState(() {
            widget.me.essentials['status'] = index;

            if (index == 0)
              this._page = 1;
            else
              this._page = 0;
            _pageController.jumpToPage(this._page);
          })
        : dispose();
  }

  void onPageChanged(int page) {
    mounted
        ? setState(() {
            this._page = page;
          })
        : dispose();
  }
}
