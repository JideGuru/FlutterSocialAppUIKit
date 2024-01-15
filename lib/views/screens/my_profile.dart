import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:group_button/group_button.dart';
import 'package:social_app_ui/util/configs/configs.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:social_app_ui/util/user.dart';
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
      body: FutureBuilder(
        future: usersColRef.doc(me.email).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            User me = User.fromFirestore(snapshot.data!);
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    ProfileCard(
                      profileMode: Owner.MINE,
                      user: me,
                      me: me,
                    ),
                    SizedBox(height: 25),
                    SizedBox(height: 25),
                    Text(consts['finding'].toString()),
                    GroupButton(
                      options: GroupButtonOptions(
                          borderRadius: BorderRadius.circular(5.0)),
                      controller: GroupButtonController(
                        selectedIndex: me.essentials['status'],
                      ),
                      onSelected: (value, index, isSelected) {
                        me.essentials['status'] = index;
                        usersColRef
                            .doc(me.email)
                            .update({'status': me.essentials['status']});
                        showToast(
                          consts['saved'].toString(),
                          context: context,
                          animation: StyledToastAnimation.fade,
                        );
                        onStatusChanged(index);
                      },
                      buttons: [
                        consts['yes'].toString(),
                        consts['no'].toString()
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Text("${consts['notification'].toString()}을 수신하시나요?"),
                    GroupButton(
                      options: GroupButtonOptions(
                          borderRadius: BorderRadius.circular(5.0)),
                      controller: GroupButtonController(
                        selectedIndex: me.essentials['notification'],
                      ),
                      onSelected: (value, index, isSelected) {
                        me.essentials['notification'] = index;
                        usersColRef.doc(me.email).update(
                            {'notification': me.essentials['notification']});
                        showToast(
                          consts['saved'].toString(),
                          context: context,
                          animation: StyledToastAnimation.fade,
                        );
                      },
                      buttons: [
                        consts['yes'].toString(),
                        consts['no'].toString()
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.1),
                  ],
                ).fadeInList(1, true),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
