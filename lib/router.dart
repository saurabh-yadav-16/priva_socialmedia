import 'package:flutter/material.dart';
import 'package:priva_socialmedia/common/widgets/error.dart';
import 'package:priva_socialmedia/features/auth/screens/login_screen.dart';
import 'package:priva_socialmedia/features/auth/screens/otp_screen.dart';
import 'package:priva_socialmedia/features/auth/screens/user_information_screen.dart';
import 'package:priva_socialmedia/features/landing/screens/landing_screen.dart';
import 'package:priva_socialmedia/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:priva_socialmedia/widgets/mobile_chat_screen.dart';

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
      // Retrieves the name and uid from the [settings.arguments] and returns a [MaterialPageRoute] for the mobile chat screen route.
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
      // Returns a [MaterialPageRoute] with an error message for routes that do not exist.
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
            body: ErrorScreen(error: 'This route does not exist'));
      });
  }
}
