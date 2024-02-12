import 'package:flutter/material.dart';
import 'package:priva_socialmedia/common/widgets/error.dart';
import 'package:priva_socialmedia/features/auth/screens/login_screen.dart';
import 'package:priva_socialmedia/features/auth/screens/otp_screen.dart';
import 'package:priva_socialmedia/features/auth/screens/user_information_screen.dart';
import 'package:priva_socialmedia/features/landing/screens/landing_screen.dart';
import 'package:priva_socialmedia/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:priva_socialmedia/widgets/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const LandingScreen());
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (_) => OTPScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (_) => const UserInformationScreen());
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    default:
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
            body: ErrorScreen(error: 'This route does not exist'));
      });
  }
}
