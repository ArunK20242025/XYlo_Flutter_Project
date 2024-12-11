import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message!)),
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
                fit: BoxFit.cover, // Makes the image cover the entire screen
              ),
            ),
          ),
          // Sign-Up Form
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
                            SizedBox(height: 90), // Increased space above the text
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Sign up and find your way 🧳',
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

                            // Email Field
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                color: Color(0xFFEED9C4), // Same background color as the login page
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
                                validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
                              ),
                            ),
                            SizedBox(height: 15),

                            // Password Field
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
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.brown),
                                  border: InputBorder.none,
                                ),
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                validator: (value) => value!.length < 8 ? 'Password must be 8+ characters' : null,
                              ),
                            ),
                            SizedBox(height: 15),

                            // Confirm Password Field
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
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(color: Colors.brown),
                                  border: InputBorder.none,
                                ),
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    confirmPassword = value;
                                  });
                                },
                                validator: (value) => value != password ? 'Passwords do not match' : null,
                              ),
                            ),
                            SizedBox(height: 30),

                            // Sign Up Button
                            ElevatedButton(
                              onPressed: _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown, // Same button color as login page
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 10),

                            // Already have an account?
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                "Already have an account? Log in",
                                style: TextStyle(color: Colors.brown),
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
