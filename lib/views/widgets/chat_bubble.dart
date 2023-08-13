import 'package:flutter/material.dart';
import 'package:social_app_ui/util/enum.dart';

class ChatBubble extends StatefulWidget {
  final Map<String, dynamic> conversation;
  final Owner sender;
  ChatBubble({
    required this.conversation,
    this.sender = Owner.MINE,
  });
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final color = widget.sender == Owner.MINE
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.onBackground;
    final align = widget.sender == Owner.MINE
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final radius = widget.sender == Owner.MINE
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
                  widget.conversation['message'],
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
        Padding(
          padding: widget.sender == Owner.MINE
              ? EdgeInsets.only(right: 10, bottom: 10.0)
              : EdgeInsets.only(left: 10, bottom: 10.0),
          child: Text(
            widget.conversation['time'].toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
