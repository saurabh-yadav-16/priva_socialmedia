import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:priva_socialmedia/features/auth/repositery/auth_repositry.dart';
import 'package:priva_socialmedia/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authReposistry = ref.watch(authReposistryprovider);
  return AuthController(ref, authRepository: authReposistry);
});

class AuthController {
  final AuthReposistry authRepository;
  final ProviderRef ref;
  AuthController(
    this.ref, {
    required this.authRepository,
  });

  final userDataAuthProvider = FutureProvider((ref) {
    final authController = ref.watch(authControllerProvider);
    return authController.getUserData();
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(
    BuildContext context,
    String verificationId,
    String userotp,
  ) {
    authRepository.verifyOTP(
      context,
      verificationId,
      userotp,
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }
}
