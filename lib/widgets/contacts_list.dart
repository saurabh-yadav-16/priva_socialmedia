import 'package:flutter/material.dart';
import 'package:priva_socialmedia/widgets/colors.dart';
import 'package:priva_socialmedia/widgets/info.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: info.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      
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
                            style: const TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        )),
                  );
                }),
          ),
              const Divider(color: dividerColor,indent: 85,)
        ],
      ),)
    );
  }
}
