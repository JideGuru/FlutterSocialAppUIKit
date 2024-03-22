// This is the Main Screen for the App
import 'package:flutter/material.dart';
import 'package:social_app_ui/views/widgets/icon_badge.dart';
import 'package:social_app_ui/views/screens/chat/chats.dart';
import 'package:social_app_ui/views/screens/friends.dart';
import 'package:social_app_ui/views/screens/home.dart';
import 'package:social_app_ui/views/screens/notifications.dart';
import 'package:social_app_ui/views/screens/profile.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
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
          Friends(),
          Home(),
          Notifications(),
          Profile(),
        ],
      ),
      // Navigation Bar: used to navigate between the Screen
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Theme.of(context).primaryColor,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Theme.of(context).colorScheme.secondary,
          textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: TextStyle(color: Colors.grey[500]),
              ),
        ),
        child: BottomNaviationBar(),
      ),
    );
  }

  dynamic BottomNaviationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.message,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.group,
          ),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'HOme',
        ),
        BottomNavigationBarItem(
          icon: IconBadge(icon: Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: navigationTapped,
      currentIndex: _page,
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
