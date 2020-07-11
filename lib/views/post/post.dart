import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),

      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        children: <Widget>[
          SizedBox(height: 10.0,),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/cm2.jpeg",
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            title: Text(
              "Mamodou",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(
              "12 min ago",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Donec sollicitudin molestie malesuada. Quisque velit nisi,"
                " pretium ut lacinia in, elementum id enim.",
            style: TextStyle(),
          ),
          SizedBox(
            height: 10.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            child: Image.asset(
              "assets/cm2.jpeg",
              height: 170.0,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),

          // User Comments here
        ],
      ),
    );
  }
}
