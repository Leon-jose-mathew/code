import 'package:code/Screenes/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:code/Screenes/Login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaTech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define your app's theme here
      ),
      home: SplashScreen(), // Set SplashScreen as the home page
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 5 seconds before navigating
    Future.delayed(Duration(seconds: 5), () {
      // Check if user is already signed in
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LogoTextAnimation(); // Your existing LogoTextAnimation widget
  }
}

class LogoTextAnimation extends StatefulWidget {
  @override
  _LogoTextAnimationState createState() => _LogoTextAnimationState();
}

class _LogoTextAnimationState extends State<LogoTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logoAnimation;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _logoAnimation = Tween<Offset>(
      begin: Offset(0, 0.2), // Move the logo slightly downward
      end: Offset(0, 0),
    ).animate(_controller);
    _textAnimation = Tween<Offset>(
      begin: Offset(0, -1), // Move the text upward
      end: Offset(0, 0),
    ).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // GestureDetector to handle navigation on touch
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Background Image (if needed)
              // Image.asset(
              //   'assets/p1_2.png',
              //   fit: BoxFit.cover,
              // ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AquaTech Text
                    SlideTransition(
                      position: _textAnimation,
                      child: Text(
                        "AquaTech",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40, // Adjust font size as needed
                          color: Colors.white,
                          decoration: TextDecoration.none, // Remove underline
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Adjust spacing as needed
                    // Animated Logo
                    SlideTransition(
                      position: _logoAnimation,
                      child: Image.asset(
                        'assets/p1_2.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}