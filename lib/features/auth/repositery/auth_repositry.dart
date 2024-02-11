// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:priva_socialmedia/common/repository/common_firebase_storage_repository.dart';

import 'package:priva_socialmedia/common/utils/utils.dart';
import 'package:priva_socialmedia/features/auth/screens/otp_screen.dart';
import 'package:priva_socialmedia/features/auth/screens/user_information_screen.dart';
import 'package:priva_socialmedia/models/user_model.dart';
import 'package:priva_socialmedia/screens/mobile_screen_layout.dart';

final authReposistryprovider = Provider(
  (ref) => AuthReposistry(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthReposistry {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthReposistry({required this.auth, required this.firestore});

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
          Navigator.pushNamed(context, OTPScreen.routeName,
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

  void verifyOTP(
    BuildContext context,
    String verificationId,
    String userotp,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userotp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackbar(
        context: context,
        content: e.message!,
      );
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileScreenLayout(),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackbar(
        context: context,
        content: e.toString(),
      );
    }

    Stream<UserModel> userData(String userId) {
      return firestore.collection('users').doc(userId).snapshots().map(
            (event) => UserModel.fromMap(
              event.data()!,
            ),
          );
    }

    void setUserState(bool isOnline) async {
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'isOnline': isOnline,
      });
    }

    showSnackbar(
      context: context,
      content: 'Please enter a valid phone number',
    );
  }
}
