import 'package:flutter/material.dart';
import 'package:social_app_ui/util/data.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration.collapsed(
            hintText: 'Search',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: (){},
          ),
        ],
      ),


      body: ListView.separated(
        padding: EdgeInsets.all(10),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Divider(),
            ),
          );
        },
        itemCount: friends.length,
        itemBuilder: (BuildContext context, int index) {
          Map friend = friends[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  friend['dp'],
                ),
                radius: 25,
              ),

              contentPadding: EdgeInsets.all(0),
              title: Text(friend['name']),
              subtitle: Text(friend['status']),
              trailing: friend['isAccept']
                  ? FlatButton(
                child: Text(
                  "Unfollow",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.grey,
                onPressed: (){},
              ):FlatButton(
                child: Text(
                  "Follow",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Theme.of(context).accentColor,
                onPressed: (){},
              ),
              onTap: (){},
            ),
          );
        },

      ),
    );
  }
}
