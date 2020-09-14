import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/view_models/user/user_view_model.dart';
import 'package:social_app_ui/views/chat/chats/chats.dart';
import 'package:social_app_ui/views/friends/friends.dart';
import 'package:social_app_ui/views/home/home.dart';
import 'package:social_app_ui/views/notifications.dart';
import 'package:social_app_ui/views/profile/profile.dart';

class MainScreenMobile extends StatefulWidget {
  @override
  _MainScreenMobileState createState() => _MainScreenMobileState();
}

class _MainScreenMobileState extends State<MainScreenMobile> {
  PageController _pageController;
  int _page = 1;

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
          canvasColor: Theme.of(context).primaryColor,
          primaryColor: Theme.of(context).accentColor,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Feather.message_circle,
              ),
              title: Text('Chat'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Feather.home,
              ),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Feather.user,
              ),
              title: Text('Profile'),
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
    _pageController = PageController(initialPage: 1);
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<UserViewModel>(context, listen: false).setUser();
      },
    );
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
