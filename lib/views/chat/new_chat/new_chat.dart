import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:social_app_ui/models/user.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/view_models/chats/new_chat_view_model.dart';
import 'package:social_app_ui/view_models/user/user_view_model.dart';
import 'package:social_app_ui/views/chat/conversation/conversation.dart';

class NewChat extends StatefulWidget {
  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<NewChatViewModel>(context, listen: false).getUsers();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewChatViewModel>(
      builder: (BuildContext context, viewModel, Widget child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'New Chat',
            ),
          ),
          body: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              buildSearchBar(viewModel),
              SizedBox(height: 20.0),
              Flexible(
                child: buildUserList(viewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  buildSearchBar(NewChatViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color:
              isDarkMode() ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
          child: Center(
            child: TextField(
              style: TextStyle(
                fontSize: 13.0,
              ),
              decoration: InputDecoration.collapsed(
                hintText: "Search by User name",
                hintStyle: TextStyle(
                  fontSize: 13.0,
                ),
              ),
              onChanged: (query) {
                viewModel.search(query);
              },
            ),
          ),
        ),
      ),
    );
  }

  bool isDarkMode() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  buildUserList(NewChatViewModel viewModel) {
    var currentUser = Provider.of<UserViewModel>(context, listen: false).user;
    if(!viewModel.loading){
      if (viewModel.filteredUsers.isEmpty) {
        return Center(child: Text("No users found"));
      } else {
        return ListView.builder(
          itemCount: viewModel.filteredUsers.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = viewModel.filteredUsers[index];
            User user = User.fromJson(doc.data);

            if(doc.documentID == currentUser.uid){
              Timer(Duration(microseconds: 3), () {
                viewModel.removeFromList(index);
              });
            }
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
              onTap: () {
                Navigator.pop(context);
                Router.pushPage(
                  context,
                  Conversation(
                    userId: doc.documentID,
                    chatId: 'newChat',
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  user.profilePicture,
                ),
              ),
              title: Text(
                user?.name,
              ),
              subtitle: Text(
                user?.email,
              ),
            );
          },
        );
      }
    }else{
      return Center(child: CircularProgressIndicator());
    }
  }
}
