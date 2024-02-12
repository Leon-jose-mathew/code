

import 'dart:io';

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String imagePath;

  ResultPage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Picked Image:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Image.file(
              File(imagePath),
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
