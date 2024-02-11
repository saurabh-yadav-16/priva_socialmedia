import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:priva_socialmedia/features/auth/repositery/auth_repositry.dart';

final authControllerProvider = Provider((ref) {
  final authReposistry = ref.watch(authReposistryprovider);
  return AuthController(authRepository: authReposistry);
});

class AuthController {
  final AuthReposistry authRepository;
  AuthController({
    required this.authRepository,
  });

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

  void saveUserDataToFirebase(BuildContext context, String name, File? image) {}
}
