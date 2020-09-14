import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/view_models/user/user_view_model.dart';
import 'package:social_app_ui/views/chat/chats/chats.dart';
import 'package:social_app_ui/views/friends/friends.dart';
import 'package:social_app_ui/views/home/home.dart';
import 'package:social_app_ui/views/notifications.dart';
import 'package:social_app_ui/views/profile/profile.dart';

class MainScreenDesktop extends StatefulWidget {
  @override
  _MainScreenDesktopState createState() => _MainScreenDesktopState();
}

class _MainScreenDesktopState extends State<MainScreenDesktop> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _page,
            onDestinationSelected: navigationTapped,
            leading: buildUserAvatar(),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Feather.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Feather.message_circle),
                label: Text('Chats'),
              ),
              NavigationRailDestination(
                icon: Icon(Feather.user),
                label: Text('Profile'),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: onPageChanged,
              children: <Widget>[
                Home(),
                Chats(),
                Profile(),
                Friends(),
                Notifications(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildUserAvatar() {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            Constants.defaultPicture,
          ),
        ),
      ],
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
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
