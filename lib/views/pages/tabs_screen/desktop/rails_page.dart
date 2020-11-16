import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:snapam/util/constants/strings.dart';
import 'package:snapam/views/pages/chat/chats.dart';
import 'package:snapam/views/pages/home.dart';
import 'package:snapam/views/pages/profile.dart';

class RailsPage extends StatefulWidget {
  @override
  _RailsPageState createState() => _RailsPageState();
}

class _RailsPageState extends State<RailsPage> {
  List tabs = [
    {'label': 'Home', 'icon': Icons.home, 'page': Home()},
    {'label': 'Chat', 'icon': Icons.message, 'page': Chats()},
    {'label': 'Profile', 'icon': Icons.person, 'page': Profile()},
  ];
  int selectedIndex = 0;
  bool extended = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          buildRail(),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                // AppBar(),
                // Divider(thickness: 1, height: 2),
                Expanded(child: tabs[selectedIndex]['page'])
              ],
            ),
          )
        ],
      ),
    );
  }

  buildRail() {
    return NavigationRail(
      leading: buildLeading(),
      extended: extended,
      labelType: NavigationRailLabelType.none,
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      destinations: [
        for (Map tab in tabs)
          NavigationRailDestination(
            icon: Icon(tab['icon']),
            // selectedIcon: Icon(e.selectedIcon),
            label: Text(tab['label']),
          )
      ],
      trailing: Container(
        child: Column(
          children: [SizedBox(height: 40.0), buildLogoutButton()],
        ),
      ),
    );
  }

  buildLeading() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      // color: Color(0xFF1a1a27),
      padding:
          EdgeInsets.symmetric(vertical: 10.0, horizontal: extended ? 10.0 : 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedContainer(
            padding: EdgeInsets.only(left: 10.0),
            width: extended ? null : 0,
            height: extended ? null : 0,
            duration: Duration(milliseconds: 500),
            child: Text(
              "$appName",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                // color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              extended
                  ? FlutterIcons.chevron_double_left_mco
                  : FlutterIcons.chevron_double_right_mco,
              // color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                extended = !extended;
              });
            },
          )
        ],
      ),
    );
  }

  buildLogoutButton() {
    return MaterialButton(
      elevation: 0.0,
      minWidth: extended ? 220 : 45,
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      onPressed: () async {
        // await locator<AuthRepository>().signOut();
        // Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      },
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Row(
        children: [
          Icon(
            Icons.power_settings_new,
            color: Colors.white,
          ),
          AnimatedContainer(
            width: extended ? null : 0,
            duration: Duration(milliseconds: 500),
            child: Row(
              children: [
                SizedBox(width: 5.0),
                Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
