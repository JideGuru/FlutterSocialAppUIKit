import 'dart:math';

import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message, time, username, type, replyText, replyName;
  final bool isMe, isGroup, isReply;

  ChatBubble(
      {required this.message,
      required this.time,
      required this.isMe,
      required this.isGroup,
      required this.username,
      required this.type,
      required this.replyText,
      required this.isReply,
      required this.replyName});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

  Color chatBubbleColor() {
    if (widget.isMe) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      if (Theme.of(context).brightness == Brightness.dark) {
        return Colors.grey[800]!;
      } else {
        return Colors.grey[200]!;
      }
    }
  }

  Color chatBubbleReplyColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.grey[600]!;
    } else {
      return Colors.grey[50]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final align =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = widget.isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: chatBubbleColor(),
            borderRadius: radius,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.3,
            minWidth: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget.isMe
                  ? SizedBox()
                  : widget.isGroup
                      ? Padding(
                          padding: EdgeInsets.only(right: 48.0),
                          child: Container(
                            child: Text(
                              widget.username,
                              style: TextStyle(
                                fontSize: 13,
                                color: colors[rNum],
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        )
                      : SizedBox(),
              widget.isGroup
                  ? widget.isMe
                      ? SizedBox()
                      : SizedBox(height: 5)
                  : SizedBox(),
              widget.isReply
                  ? Container(
                      decoration: BoxDecoration(
                        color: chatBubbleReplyColor(),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 25,
                        maxHeight: 100,
                        minWidth: 80,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.isMe ? "You" : widget.replyName,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            SizedBox(height: 2.0),
                            Container(
                              child: Text(
                                widget.replyText,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.titleLarge?.color,
                                  fontSize: 10.0,
                                ),
                                maxLines: 2,
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(width: 2.0),
              widget.isReply ? SizedBox(height: 5) : SizedBox(),
              Padding(
                padding: EdgeInsets.all(widget.type == "text" ? 5 : 0),
                child: widget.type == "text"
                    ? !widget.isReply
                        ? Text(
                            widget.message,
                            style: TextStyle(
                              color: widget.isMe
                                  ? Colors.white
                                  : Theme.of(context).textTheme.titleLarge?.color,
                            ),
                          )
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.message,
                              style: TextStyle(
                                color: widget.isMe
                                    ? Colors.white
                                    : Theme.of(context).textTheme.titleLarge?.color,
                              ),
                            ),
                          )
                    : Image.asset(
                        "${widget.message}",
                        height: 130,
                        width: MediaQuery.of(context).size.width / 1.3,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
        ),
        Padding(
          padding: widget.isMe
              ? EdgeInsets.only(right: 10, bottom: 10.0)
              : EdgeInsets.only(left: 10, bottom: 10.0),
          child: Text(
            widget.time,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 10.0,
            ),
          ),
        ),
      ],
    );
  }
}
