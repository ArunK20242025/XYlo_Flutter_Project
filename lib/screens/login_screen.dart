import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Function for regular email login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
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

  // Function for Google sign-in
  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    
    try {
      print('Attempting to sign in with Google...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in canceled.')),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('Google sign-in completed. User: $googleUser');

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/home');
      
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred.')),
      );
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
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
                image: AssetImage('assets/gif/login_bg.png'),
                fit: BoxFit.cover, // Makes the image cover the entire screen
              ),
            ),
          ),
          // Login Form
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
                                  'Welcome to XYlo 🚗..',
                                  textStyle: TextStyle(
                                    fontSize: 59,
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
                            SizedBox(height: 30),

                            // Regular Login Button
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 10),

                            // Row to align Google Sign-in and Manual Login buttons horizontally
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Google Sign-in Button
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  width: MediaQuery.of(context).size.width * 0.4,
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
                                  child: ElevatedButton(
                                    onPressed: _signInWithGoogle,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/google_logo.png',
                                          height: 30,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Google', style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10), // Space between the buttons

                                // Manual Login Button
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  width: MediaQuery.of(context).size.width * 0.4,
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
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/anonymousLogin');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/login_manual.png', // Replace with your image path
                                          height: 30,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Manual', style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
