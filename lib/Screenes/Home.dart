import 'package:flutter/material.dart';
import 'profile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color.fromARGB(255, 1, 58, 1), // Highlight color
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _currentIndex == 0 ? Color.fromARGB(255, 51, 78, 48) : null,
              ),
              child: Image.asset(
                'assets/home.png',
                width: 30,
                height: 30,
                color: _currentIndex == 0 ? Colors.white : null,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _currentIndex == 1 ? Color.fromARGB(255, 51, 78, 48) : null,
              ),
              child: Image.asset(
                'assets/user.png',
                width: 30,
                height: 30,
                color: _currentIndex == 1 ? Colors.white : null,
              ),
            ),
            label: '',
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
      _uploadImage(context, File(pickedImage.path));
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      _uploadImage(context, File(pickedImage.path));
    }
  }

  Future<void> _uploadImage(BuildContext context, File image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("images/${DateTime.now().toString()}");
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageURL = await taskSnapshot.ref.getDownloadURL();
      
      // Get the current user's ID
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'imageURL': imageURL,
        });
        print('Image uploaded to Firebase Storage: $imageURL');
      } else {
        print('User is not authenticated.');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0), // Adjust the top padding as needed
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Do they need water?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 222, 222, 222),
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
            color: Color.fromARGB(255, 24, 61, 17).withOpacity(0.5),
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
                color: const Color.fromARGB(255, 6, 6, 6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
