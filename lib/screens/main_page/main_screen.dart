import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:social_app_ui/components/icon_badge.dart';
import 'package:social_app_ui/screens/chat/chats/chats.dart';
import 'package:social_app_ui/screens/friends/friends.dart';
import 'package:social_app_ui/screens/home/home.dart';
import 'package:social_app_ui/screens/notifications.dart';
import 'package:social_app_ui/screens/profile/profile.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          Chats(),
          Home(),
          Profile(),
          Friends(),
          Notifications(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Theme.of(context).primaryColor,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.grey[500]),
              ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Feather.message_circle,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Feather.home,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Feather.user,
              ),
              title: Container(height: 0.0),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
