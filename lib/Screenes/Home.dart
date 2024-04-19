import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'result.dart';
import 'profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 34, 158, 34),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
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
      _runModel(context, File(pickedImage.path));
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
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

    String label = '';

    if (output != null && output.isNotEmpty) {
      label = output[0]['label'];
    }

    // Convert label to int
    int prediction = int.tryParse(label) ?? 0;

    // Store prediction in Realtime Database
    storePrediction(prediction);

    // Navigate to ResultPage with the inference result
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultPage(prediction: prediction, imagePath: imageFile.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Do they need water?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 40),
            _buildButton(
              'Upload from Gallery',
              'assets/gallery.png',
              () => _openGallery(context),
            ),
            const SizedBox(height: 20),
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
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 162, 191, 154).withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 5,
            offset: const Offset(0, 3),
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
            const SizedBox(height: 10),
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void storePrediction(int prediction) {
  DatabaseReference waterRef =
      FirebaseDatabase.instance.reference().child('water');

  // Define the water amount based on prediction
  int waterAmount;
  switch (prediction) {
    case 1:
      waterAmount = 200;
      break;
    case 2:
      waterAmount = 230;
      break;
    case 3:
      waterAmount = 250;
      break;
    case 4:
      waterAmount = 300;
      break;
    case 5:
      waterAmount = 400;
      break;
    case 6:
      waterAmount = 450;
      break;
    default:
      print('Invalid prediction');
      return; // Exit the function if prediction is invalid
  }

  // Store the water amount in the Realtime Database
  waterRef.child('amount').set(waterAmount).then((_) {
    print('Water amount stored successfully');
  }).catchError((error) {
    print('Failed to store water amount: $error');
  });
}
