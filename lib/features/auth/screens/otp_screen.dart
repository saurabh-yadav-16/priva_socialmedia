import 'package:flutter/material.dart';

class OTPscreen extends StatefulWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  const OTPscreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OTPscreen> createState() => _OTPscreenState();
}

class _OTPscreenState extends State<OTPscreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('OTP Screen'),
      ),
    );
  }
}
