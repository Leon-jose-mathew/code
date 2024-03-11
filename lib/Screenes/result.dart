
import 'dart:io';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String label;
  final String imagePath;

  const ResultPage({Key? key, required this.label, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              File(imagePath),
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            label.isNotEmpty
                ? Text(
                    'Label: $label',
                    style: TextStyle(fontSize: 24),
                  )
                : Text(
                    'No result found for this image.',
                    style: TextStyle(fontSize: 24),
                  ),
          ],
        ),
      ),
    );
  }
}

