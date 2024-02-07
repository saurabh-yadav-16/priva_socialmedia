import 'package:flutter/material.dart';
import 'package:priva_socialmedia/widgets/colors.dart';
import 'package:priva_socialmedia/widgets/info.dart';
import 'package:priva_socialmedia/widgets/my_message_card.dart';

class Chatlist extends StatelessWidget {
  const Chatlist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (messages[index]['isme'] == true) {
          return MyMessageCard(
            message: messages[index]['text'].toString(),
            date: messages[index]['date'].toString(),
          );
        }
        return MyMessageCard(
          message: messages[index]['text'].toString(),
          date: messages[index]['date'].toString(),
        );
      },
    );
  }
}
