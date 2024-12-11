import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnonymousLoginScreen extends StatefulWidget {
  @override
  _AnonymousLoginScreenState createState() => _AnonymousLoginScreenState();
}

class _AnonymousLoginScreenState extends State<AnonymousLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name = '';
  String email = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _signInAnonymously() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        // Sign in anonymously
        await _auth.signInAnonymously();
        // Navigate to home screen after successful login
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/gif/login_bg.png'), // Same background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Anonymous Login Form
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated Welcome Text
                            SizedBox(height: 90),
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Incognito Mode activated! 🌚',
                                  textStyle: TextStyle(
                                    fontSize: 49,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.brown,
                                  ),
                                  speed: Duration(milliseconds: 130),
                                ),
                              ],
                              totalRepeatCount: 1,
                            ),
                            SizedBox(height: 230), // Space below the welcome text

                            // Name Field
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                color: Color(0xFFEED9C4),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(color: Colors.brown),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                              ),
                            ),
                            SizedBox(height: 15),

                            // Email Field
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                color: Color(0xFFEED9C4),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.brown),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                              ),
                            ),
                            SizedBox(height: 30),

                            // Login Anonymously Button
                            ElevatedButton(
                              onPressed: _signInAnonymously,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Login Anonymously",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
