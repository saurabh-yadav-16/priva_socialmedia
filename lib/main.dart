// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:priva_socialmedia/colors.dart';

void main() {
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
          backgroundColor: backgroundColor,
        ),
        home: const Text('Priva'));
  }
}
