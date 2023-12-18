import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/enum.dart';

class ChatBubble extends StatefulWidget {
  final bool withDayBar, withRead;
  final Map<String, dynamic> message;
  final Owner sender;
  ChatBubble({
    required this.withDayBar,
    required this.withRead,
    required this.message,
    required this.sender,
  });
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final color = widget.sender == Owner.MINE
        ? Color.fromRGBO(12, 73, 127, 1)
        : Color.fromRGBO(144, 144, 144, 1.0);
    final align = widget.sender == Owner.MINE
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
    final radius = widget.sender == Owner.MINE
        ? BorderRadius.only(
            topLeft: Radius.circular(18.0),
            bottomLeft: Radius.circular(18.0),
            bottomRight: Radius.circular(18.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(18.0),
            bottomLeft: Radius.circular(18.0),
            bottomRight: Radius.circular(18.0),
          );
    var time = (widget.message['time'] as Timestamp)
        .toDate()
        .toIso8601String()
        .split('T');
    return Column(
      children: [
        Visibility(
          visible: widget.withDayBar,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 145,
                height: 1,
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
              Text(
                time[0].toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(
                width: 145,
                height: 1,
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: align,
          children: <Widget>[
            Visibility(
              visible: widget.sender == Owner.MINE,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: widget.withRead,
                    child: Text(
                      '읽음',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    "${time[1].substring(0, 5)}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: color,
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
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget.message['message'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: widget.sender == Owner.MINE
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.sender == Owner.OTHERS,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "${time[1].substring(0, 5)}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
