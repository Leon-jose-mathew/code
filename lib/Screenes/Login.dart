import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart'; // Assuming the SignUpPage is in a file named signup.dart
import 'Home.dart'; // Assuming the ProfilePage is in a file named profile.dart

class SignInPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to the Home page after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      // Handle sign-in errors
      print("Error signing in: $e");
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in. Please check your credentials."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/sign_in.png', // Assuming the background image is named sign_in.png
            fit: BoxFit.cover,
          ),
          // Centered Sign In text
          Positioned(
            top: 80, // Adjust top position as needed
            left: 20, // Adjust left position as needed
            child: Text(
              'Sign In',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Sign In Form
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Enter Email TextField
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Enter Email',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white), // Border color
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Enter Password TextField
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Enter Password',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white), // Border color
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Sign In Button with Gradient
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 2, 43, 10),
                          Colors.green
                        ], // Adjust gradient colors as needed
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _signIn(context); // Attempt to sign in
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Make button transparent
                        shadowColor: Colors.transparent, // Remove button shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // "Don't have an account? Sign Up" text
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 -
                100, // Center horizontally
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
