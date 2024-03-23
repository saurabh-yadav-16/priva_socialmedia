import 'package:flutter/material.dart';
import 'package:priva_socialmedia/widgets/info.dart';
import 'package:priva_socialmedia/widgets/my_message_card.dart';
import 'package:priva_socialmedia/widgets/sender_message_card.dart';

/// A widget that displays a list of chat messages.
class Chatlist extends StatelessWidget {
  const Chatlist({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (messages[index]['isMe'] == true) {
          return MyMessageCard(
            message: messages[index]['text'].toString(),
            date: messages[index]['time'].toString(),
          );
        }
        return SenderMessageCard(
          message: messages[index]['text'].toString(),
          date: messages[index]['date'].toString(),
        );
      },
    );
  }
}
