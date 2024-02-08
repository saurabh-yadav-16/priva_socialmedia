import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:priva_socialmedia/features/landing/screens/landing_screen.dart';
import 'package:priva_socialmedia/firebase_options.dart';
import 'package:priva_socialmedia/widgets/colors.dart';
import 'package:priva_socialmedia/responsive/responsive_layout.dart';
import 'package:priva_socialmedia/screens/mobile_screen_layout.dart';
import 'package:priva_socialmedia/screens/web_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Priva',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const LandingScreen(),
    );
  }
}
