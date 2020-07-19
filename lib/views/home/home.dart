import 'package:flutter/material.dart';
import 'package:social_app_ui/components/post_item.dart';
import 'package:social_app_ui/views/post/add_post.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/router.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          Map post = posts[index];
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 10.0 : 0.0),
            child: PostItem(
              img: post['img'],
              name: post['name'],
              dp: post['dp'],
              time: post['time'],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Router.pushPageDialog(context, AddPost());
        },
      ),
    );
  }
}
