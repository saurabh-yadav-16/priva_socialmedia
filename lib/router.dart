import 'package:flutter/material.dart';
import 'package:priva_socialmedia/common/widgets/error.dart';
import 'package:priva_socialmedia/features/auth/screens/login_screen.dart';
import 'package:priva_socialmedia/features/landing/screens/landing_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const LandingScreen());
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    default:
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
            body: ErrorScreen(error: 'This route does not exist'));
      });
  }
}
