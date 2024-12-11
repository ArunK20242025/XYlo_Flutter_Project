// splash_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xylo/screens/custom_loading_screen.dart'; // Import your custom loading screen

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CustomLoadingScreen(), // Navigate to loading screen
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CustomLoadingScreen(), // Navigate to loading screen
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: CircularProgressIndicator()), // Placeholder while checking auth
    );
  }
}
