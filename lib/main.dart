import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:priva_socialmedia/common/widgets/error.dart';
import 'package:priva_socialmedia/common/widgets/loader.dart';
import 'package:priva_socialmedia/features/auth/controller/auth_controller.dart';
import 'package:priva_socialmedia/features/landing/screens/landing_screen.dart';
import 'package:priva_socialmedia/firebase_options.dart';
import 'package:priva_socialmedia/router.dart';
import 'package:priva_socialmedia/screens/mobile_layout_screen.dart';
import 'package:priva_socialmedia/widgets/colors.dart';

// Initialize Firebase and run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app wrapped in a ProviderScope
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// The main app widget
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Priva UI',

      // Set the dark theme for the app
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),

      // Define the route generator for the app
      onGenerateRoute: (settings) => generateRoute(settings),

      // Set the home screen based on the user's authentication state
      home: Consumer(
        builder: (context, ref, child) {
          final userAsyncValue = ref.watch(userDataAuthProvider);
          return userAsyncValue.when(
            data: (user) {
              if (user == null) {
                // Show the landing screen if the user is not authenticated
                return const LandingScreen();
              }
              // Show the main app screen if the user is authenticated
              return const MobileScreenLayout();
            },
            error: (err, trace) {
              // Show an error screen if there is an error fetching user data
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          );
        },
      ),
    );
  }
}
