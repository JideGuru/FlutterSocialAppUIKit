import 'package:flutter/material.dart';
import 'package:social_app_ui/util/configs/configs.dart';

class Settings extends StatefulWidget {
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
          SizedBox(),
          Row(
            children: [],
          ),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}
