import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Priva/common/utils/colors.dart';
import 'package:Priva/common/utils/utils.dart';
import 'package:Priva/features/auth/controller/auth_controller.dart';
import 'package:Priva/features/group/screens/create_group_screen.dart';
import 'package:Priva/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:Priva/features/chat/widgets/contacts_list.dart';
import 'package:Priva/features/status/screens/confirm_status_screen.dart';
import 'package:Priva/features/status/screens/status_contacts_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    tabBarController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: Hero(
            tag: 'appBarTitle',
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Priva',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Create Group'),
                  onTap: () => Navigator.pushNamed(
                    context,
                    CreateGroupScreen.routeName,
                  ),
                )
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat),
                    SizedBox(width: 5),
                    Text('CHATS'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rss_feed),
                    SizedBox(width: 5),
                    Text('FEED'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 5),
                    Text('CALLS'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: const [
            ContactsList(),
            StatusContactsScreen(),
            Text('Calls'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabBarController.index == 0) {
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(
                  context,
                  ConfirmStatusScreen.routeName,
                  arguments: pickedImage,
                );
              }
            }
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
