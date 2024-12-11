import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ARScreen extends StatelessWidget {
  const ARScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove AppBar to make it fullscreen
      appBar: null,
      body: Stack(
        children: [
          // Background Image with a slightly zoomed-out fit to fill the screen
          Positioned.fill(
            child: Image.asset(
              'assets/gif/ar_view.gif', // Replace with your image path
              fit: BoxFit.cover, // Ensures image covers the screen while keeping aspect ratio
            ),
          ),
          // Foreground Content
          Align(
            alignment: Alignment.bottomCenter, // Aligns the button to the bottom center
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Adds padding from the edges
              child: ModernButton(
                onPressed: () => _showModernDialog(context),
                text: "Open AR View",
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showModernDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_rounded, size: 60, color: Colors.orange),
                  const SizedBox(height: 20),
                  const Text(
                    "CAUTION",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please pay attention to your surroundings and refrain from using while walking.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.place, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(child: Text("Represents the destination")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.arrow_forward, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(child: Text("Points towards the destination")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.horizontal_rule, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(child: Text("Represents the route to the destination")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          // Navigate to the AR camera screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ARCameraScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text("Understood"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom modern button widget
class ModernButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ModernButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Slightly smaller button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // No rounded corners
        ),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16, // Slightly smaller font size
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// AR Camera Screen (to open the camera)
class ARCameraScreen extends StatefulWidget {
  const ARCameraScreen({Key? key}) : super(key: key);

  @override
  _ARCameraScreenState createState() => _ARCameraScreenState();
}

class _ARCameraScreenState extends State<ARCameraScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    await _cameraController.initialize();

    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR Camera View")),
      body: _isCameraInitialized
          ? CameraPreview(_cameraController)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ARScreen(),
  ));
}
