import 'package:flutter/material.dart';
import 'profile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'result.dart';
import 'package:flutter_tflite/flutter_tflite.dart'; // Add TensorFlow Lite package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Home(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color.fromARGB(255, 34, 158, 34), // Highlight color
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  Future<void> _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Navigate to ResultPage with the picked image path
      _runModel(context, File(pickedImage.path));
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      // Navigate to ResultPage with the picked image path
      _runModel(context, File(pickedImage.path));
    }
  }

  Future<void> _runModel(BuildContext context, File imageFile) async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );

    final output = await Tflite.runModelOnImage(
      path: imageFile.path,
      numResults: 1,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    String label = ''; // Initialize label as empty

    if (output != null && output.isNotEmpty) {
      label = output[0]['label']; // Get the label if result is found
    }
    // Navigate to ResultPage with the inference result
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
            label: label = label, imagePath: imageFile.path),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 20.0), // Adjust the top padding as needed
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Do they need water?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(height: 40),
            _buildButton(
              'Upload from Gallery',
              'assets/gallery.png',
              () => _openGallery(context),
            ),
            SizedBox(height: 20),
            _buildButton(
              'Capture the Image',
              'assets/camera.png',
              () => _openCamera(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String buttonText,
    String imagePath,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 162, 191, 154).withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 100,
              height: 100,
            ),
            SizedBox(height: 10),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
