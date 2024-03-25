import 'package:flutter/material.dart';
import 'package:priva_socialmedia/common/widgets/custom_button.dart';
import 'package:priva_socialmedia/common/utils/colors.dart';
import 'package:priva_socialmedia/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

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
              color: tabColor,
            ),
            SizedBox(height: size.height / 9),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Don't let your secrets become a leak, with Priva, your privacy is strong and sleek.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                  text: 'Agree and continue',
                  onPressed: () => _navigateToLogin(context),
                  color: tabColor,
                  textColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
