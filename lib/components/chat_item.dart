import 'package:flutter/material.dart';
import 'package:social_app_ui/screens/chat/conversation/conversation.dart';

class ChatItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String msg;
  final bool isOnline;
  final int counter;

  ChatItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.msg,
    @required this.isOnline,
    @required this.counter,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      leading: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage(
              "${widget.dp}",
            ),
            radius: 25.0,
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
              ),
              height: 15,
              width: 15,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isOnline
                        ? Color(0xff00d72f)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  height: 11,
                  width: 11,
                ),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        "${widget.name}",
        maxLines: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${widget.msg}",
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            "${widget.time}",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 11,
            ),
          ),
          SizedBox(height: 5),
          buildCounter(),
        ],
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Conversation();
            },
          ),
        );
      },
    );
  }

  buildCounter(){
    if(widget.counter == 0){
      return SizedBox();
    }else{
      return Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        constraints: BoxConstraints(
          minWidth: 11,
          minHeight: 11,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 1, left: 5, right: 5),
          child: Text(
            "${widget.counter}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
