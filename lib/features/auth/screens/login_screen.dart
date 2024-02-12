import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:priva_socialmedia/common/utils/utils.dart';
import 'package:priva_socialmedia/common/widgets/custom_button.dart';
import 'package:priva_socialmedia/features/auth/controller/auth_controller.dart';
import 'package:priva_socialmedia/widgets/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      favorite: ['IN'],
      context: context,
      showPhoneCode: true, // Add this line to show the country code
      onSelect: (Country country) {
        setState(() {
          this.country = country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    final phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      final fullPhoneNumber = '+${country?.phoneCode}$phoneNumber';
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, fullPhoneNumber);
    } else {
      showSnackBar(
        context: context,
        content: 'Please enter a valid phone number',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        title: const Text(
          'Enter your phone number',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Please enter your phone number to verify your account.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40), // Add SizedBox here
              const SizedBox(height: 10),
              GestureDetector(
                onTap: pickCountry, // Attach pickCountry function here
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80, // Reduce width of country code box
                      height: 60, // Increase height of country code box
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    8.0), // Reduce space between code and icon
                            child: Text(
                              '+${country?.phoneCode ?? '00 '}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: size.width * 0.6,
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: tabColor, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.6,
              ),
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: sendPhoneNumber,
                  text: 'Next',
                  color: tabColor,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
