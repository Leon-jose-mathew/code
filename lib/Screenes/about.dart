import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.black, // Set app bar background color to black
        title: Text(
          'About Our App',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place the image at the top center
            Center(
              child: Image.asset(
                'assets/p1_2.png',
                height: 120,
                width: 120,
              ),
            ),
            SizedBox(height: 20),
            // Text content with left alignment and white color
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Our app is a cutting-edge agricultural solution designed to revolutionize plant cultivation and resource management, with a focus on rapidly growing plant species. It comprises three main components: advanced plant stage identification using machine learning-based image analysis, optimized irrigation through sensor-driven water management, and precise water delivery via an automated sprinkler system. By harnessing the power of machine learning for image recognition, mobile app technology for water level monitoring, and IoT for irrigation control, our project aims to promote robust plant growth and efficient water usage. This integration of technologies holds great promise for boosting agricultural productivity and ensuring the sustainable use of water resources, contributing to a brighter, more environmentally conscious future.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.justify, // Justify the text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
