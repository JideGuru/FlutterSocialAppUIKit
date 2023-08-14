import 'package:flutter/material.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/chat/chats.dart';
import 'package:social_app_ui/views/screens/home.dart';

import 'package:social_app_ui/views/screens/my_profile.dart';
import 'package:social_app_ui/views/screens/settings.dart';

class MainScreen extends StatefulWidget {
  late final User user;
  MainScreen({
    super.key,
    required this.user,
  });
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          Home(user: widget.user),
          MyProfile(user: widget.user),
          Chats(user: widget.user),
          Settings(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: '내 프로필',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: '설정',
          ),
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

  void onPageChanged(int page) {
    mounted
        ? setState(() {
            this._page = page;
          })
        : dispose();
  }
}
