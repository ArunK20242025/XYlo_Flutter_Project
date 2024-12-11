// main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xylo/screens/splash_screen.dart';

import 'screens/anonymous_login_screen.dart';
import 'screens/direction_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart'; // Import the ProfileScreen
import 'screens/search_screen.dart';   // Import the SearchScreen (if you have this already)
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XYlo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/anonymousLogin': (context) => AnonymousLoginScreen(),
        '/home': (context) {
          final User? user = FirebaseAuth.instance.currentUser;
          return HomeScreen(user: user);
        },
        '/profile': (context) {
          final User? user = FirebaseAuth.instance.currentUser;
          return ProfileScreen(userName: user?.displayName ?? 'User'); // Pass user name
        },
        '/search': (context) => SearchScreen(), // Assuming you have a SearchScreen
        '/directions': (context) => const DirectionScreen(user: null,), // Add the DirectionsScreen route
      },
    );
  }
}
