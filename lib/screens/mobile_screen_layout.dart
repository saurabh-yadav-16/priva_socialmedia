import 'package:flutter/material.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Priva',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.message)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Home')),
            Center(child: Text('Messages')),
            Center(child: Text('Profile')),
          ],
        ),
      ),
    );
  }
}
