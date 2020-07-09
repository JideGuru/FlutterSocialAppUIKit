import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:social_app_ui/components/custom_card.dart';

class PostItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;

  PostItem(
      {Key key,
      @required this.dp,
      @required this.name,
      @required this.time,
      @required this.img})
      : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool faved = Random().nextBool();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: CustomCard(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
//        elevation: 4,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      "${widget.dp}",
                    ),
                  ),
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    "${widget.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "${widget.time}",
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
                    "${widget.img}",
                    height: 170.0,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Divider(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () {},
                      icon: faved
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Feather.heart,
                            ),
                      label: Text(
                        "108",
                      ),
                    ),
                    FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Feather.message_circle,
                      ),
                      label: Text(
                        "10",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
