import 'dart:io';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String label;
  final String imagePath;

  const ResultPage({Key? key, required this.label, required this.imagePath})
      : super(key: key);

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
              width: 400,
              height: 400,
            ),
            SizedBox(height: 20),
            label.isNotEmpty
                ? Text(
                    '$label',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
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
