import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_ui/util/chat_util.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/views/widgets/chat_bubble.dart';

class Conversation extends StatefulWidget {
  final String email;
  final Chat chat;
  Conversation({
    super.key,
    required this.email,
    required this.chat,
  });
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  String _typed = "";
  @override
  Widget build(BuildContext context) {
    var convDoc = FirebaseFirestore.instance
        .collection('chats')
        .doc('myEmail.jbnu.ac.kr');
    // convDoc.snapshots().listen(
    //   (event) {
    //     var eventedConv = event.data()![widget.chat.email];
    //     var eventedChat = Chat(
    //       email: widget.chat.email,
    //       nickname: widget.chat.nickname,
    //       conversations: eventedConv,
    //     );
    //     if (widget.chat.conversations.length !=
    //         eventedChat.conversations.length) {
    //       print(widget.chat.conversations.length);
    //       print(eventedChat.conversations.length);
    //       print('event occured');
    //     }
    //   },
    // );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: InkWell(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.chat.nickname,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      widget.chat.email,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_horiz,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: widget.chat.conversations.length,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  var lastIndex = widget.chat.conversations.length - 1;
                  var conversation =
                      widget.chat.conversations[lastIndex - index];
                  return ChatBubble(
                    conversation: conversation,
                    sender: conversation['sender'] == widget.chat.email
                        ? Owner.OTHERS
                        : Owner.MINE,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomAppBar(
                elevation: 10,
                color: Theme.of(context).colorScheme.secondary,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: MediaQuery.of(context).size.width - 25,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      constraints: BoxConstraints(
                        maxHeight: 100,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                _typed = value;
                                setState(() {});
                              },
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintText: "메시지를 작성해주세요.",
                                hintStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              maxLines: null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                            ),
                            onPressed: _typed.isEmpty
                                ? null
                                : () {
                                    var typedToFirestore =
                                        widget.chat.typedToFirestore(
                                      widget.email,
                                      _typed,
                                      Owner.MINE,
                                    );
                                    var path = FieldPath(
                                      [widget.chat.email],
                                    );
                                    convDoc.update({
                                      path: FieldValue.arrayUnion(
                                          typedToFirestore)
                                    });
                                    setState(() {});
                                  },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
