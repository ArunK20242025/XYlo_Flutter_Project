// custom_loading_screen.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:xylo/screens/login_screen.dart';

class CustomLoadingScreen extends StatefulWidget {
  @override
  _CustomLoadingScreenState createState() => _CustomLoadingScreenState();
}

class _CustomLoadingScreenState extends State<CustomLoadingScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    playMusic();
    navigateToLogin();
  }

  void playMusic() async {
    await _audioPlayer.play(AssetSource('music/loading_music.mp3'));
  }

  void navigateToLogin() {
    Future.delayed(Duration(seconds: 7), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      _audioPlayer.stop();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFCFEFC), // Background color #FCFEFC
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Increase GIF size by adjusting width and height
              Image.asset('assets/gif/loading_ani.gif', width: 300, height: 300), // Custom GIF
              SizedBox(height: 20),
              Text(
                "Hang tight, we're loading...",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
