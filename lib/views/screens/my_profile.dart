import 'package:flutter/material.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/user.dart';
import 'package:social_app_ui/views/screens/details/detail.dart';
import 'package:social_app_ui/views/widgets/profile_card.dart';

class MyProfile extends StatelessWidget {
  final User me;
  final Function onStatusChanged;
  MyProfile({
    super.key,
    required this.me,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          consts['my-profile'].toString(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              ProfileCard(profileMode: Owner.MINE, user: me),
              SizedBox(height: 25),
              Text(me.email, style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 25),
              Text(consts['finding'].toString()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ToggleButtons(
                  children: [
                    Text(consts['yes'].toString()),
                    Text(consts['no'].toString()),
                  ],
                  isSelected: [
                    me.essentials['status'] == 0,
                    me.essentials['status'] == 1,
                  ],
                  onPressed: (index) {
                    me.essentials['status'] = index;
                    usersColRef.doc(me.email).update({
                      'status': index,
                    });
                    onStatusChanged(index);
                  },
                ),
              ),
              SizedBox(height: 50),
              Text(
                consts['modify'].toString(),
                style: TextStyle(),
              ),
              SizedBox(height: screenHeight * 0.1),
              Detail(user: me, detailMode: Owner.MINE),
            ],
          ).fadeInList(1, true),
        ),
      ),
    );
  }
}
