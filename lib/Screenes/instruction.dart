import 'package:flutter/material.dart';
import 'login.dart'; // Import the login page
import 'Home.dart'; // Import the home page

class InstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add your instruction content here
            Text(
              'Welcome to AquaTech!',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '1. You can know the current growth phase of the plant by scanning the image.',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Text(
              '2. You can know the amount of water needed for your plant.',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            // Add more instructions as needed
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  SignInPage()),
          );
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}