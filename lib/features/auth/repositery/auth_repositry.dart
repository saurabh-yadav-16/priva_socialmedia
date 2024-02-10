import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:priva_socialmedia/common/utils/utils.dart';
import 'package:priva_socialmedia/features/auth/screens/otp_screen.dart';

class AuthReposistry {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthReposistry({required this.auth, required this.firestore});
}

void signInWithPhone(BuildContext context, String phoneNumber) async {
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackbar(context: context, content: e.message!);
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pushNamed(context, OTPscreen.routeName,
            arguments: verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  } on FirebaseAuthException catch (e) {
    showSnackbar(context: context, content: e.message!);
  }
}
