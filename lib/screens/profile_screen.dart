// screens/profile_screen.dart

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userName; // Replace with appropriate user data if needed

  const ProfileScreen({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $userName!',
              style: TextStyle(fontSize: 24),
            ),
            // Add more profile information here
          ],
        ),
      ),
    );
  }
}
