import 'package:flutter/material.dart';
import 'package:priva_socialmedia/widgets/contacts_list.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //profile bar
                ContactList(),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assests\\backgroundImage.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ));
  }
}
