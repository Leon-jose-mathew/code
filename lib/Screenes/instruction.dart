import 'package:flutter/material.dart';
import 'login.dart'; // Import the login page
import 'Home.dart'; // Import the home page

class InstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Image.asset(
                'assets/p1_2.png',
                height: 120,
                width: 120,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated Instruction Content
                    FadeIn(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to AquaTech!',
                            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Instructions:',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '1. You must login with a valid email id and password.',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Roboto'),
                          ),
                          Text(
                            '2. If you do not have account please create it by clicking the signup button.',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Roboto'),
                          ),
                          Text(
                            '3. You can know the current growth phase of the plant by scanning the image.',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Roboto'),
                          ),
                          Text(
                            '4. You can know the amount of water needed for your plant.',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Roboto'),
                          ),
                          Text(
                            '5. You can provide water for your plant.',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Roboto'),
                          ),
                          // Add more instructions as needed
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        },
        child: Icon(Icons.arrow_forward),
        elevation: 2.0, // Add a subtle elevation effect
        backgroundColor: Colors.green, // Change color as needed
      ),
    );
  }
}

// Animated FadeIn Widget
class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  FadeIn({required this.child, this.duration = const Duration(milliseconds: 500)});

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
