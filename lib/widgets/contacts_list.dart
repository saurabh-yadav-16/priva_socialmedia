import 'package:flutter/material.dart';
import 'package:priva_socialmedia/widgets/colors.dart';
import 'package:priva_socialmedia/widgets/info.dart';
import 'package:priva_socialmedia/widgets/mobile_chat_screen.dart';

/// A widget that displays a list of contacts.
class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: info.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MobileChatScreen.routeName,
                      arguments: {
                        'name': info.elementAt(index)['name'].toString(),
                        'uid': info.elementAt(index)['uid'].toString(),
                      },
                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              info.elementAt(index)['profile'].toString()),
                        ),
                        title: Text(
                          info.elementAt(index)['name'].toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            info.elementAt(index)['message'].toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        trailing: Text(
                          info.elementAt(index)['time'].toString(),
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      )),
                ),
                const Divider(
                  color: dividerColor,
                  indent: 85,
                ),
              ],
            );
          }),
    );
  }
}
