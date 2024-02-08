import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Welcome to Priva!',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: size.height / 9),
            const Image(
              image: AssetImage('assets/bg.png'),
              height: 340,
              width: 340,
            ),
          ],
        ),
      ),
    );
  }
}
