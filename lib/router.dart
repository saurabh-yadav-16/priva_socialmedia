import 'dart:io';

import 'package:flutter/material.dart';
import 'package:priva_socialmedia/common/widgets/error.dart';
import 'package:priva_socialmedia/features/auth/screens/login_screen.dart';
import 'package:priva_socialmedia/features/auth/screens/otp_screen.dart';
import 'package:priva_socialmedia/features/auth/screens/user_information_screen.dart';
import 'package:priva_socialmedia/features/group/screens/create_group_screen.dart';
import 'package:priva_socialmedia/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:priva_socialmedia/features/chat/screens/mobile_chat_screen.dart';
import 'package:priva_socialmedia/features/status/screens/confirm_status_screen.dart';
import 'package:priva_socialmedia/features/status/screens/status_screen.dart';
import 'package:priva_socialmedia/models/status_model.dart';
import 'package:priva_socialmedia/features/landing/screens/landing_screen.dart';

/// Generates the appropriate route based on the provided [settings].
/// Returns a [MaterialPageRoute] for each route.
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case '/':
      // Returns a [MaterialPageRoute] for the home route.
      return MaterialPageRoute(builder: (_) => const LandingScreen());

    case LoginScreen.routeName:
      // Returns a [MaterialPageRoute] for the login screen route.
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case OTPScreen.routeName:
      // Retrieves the verification ID from the [settings.arguments] and returns a [MaterialPageRoute] for the OTP screen route.
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (_) => OTPScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      // Returns a [MaterialPageRoute] for the user information screen route.
      return MaterialPageRoute(builder: (_) => const UserInformationScreen());

    case SelectContactsScreen.routeName:
      // Returns a [MaterialPageRoute] for the select contacts screen route.
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );

    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
          file: file,
        ),
      );

    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );
      
    default:
      // Returns a [MaterialPageRoute] with an error message for routes that do not exist.
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
            body: ErrorScreen(error: 'This page does not exist'));
      });
  }
}
