
import 'dart:io';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int prediction;
  final String imagePath;

  const ResultPage({Key? key, required this.prediction, required this.imagePath})
      : super(key: key);

  String _getPredictionDescription(int prediction) {
    switch (prediction) {
      case 1:
        return '0-15 days healthy, 200ml required';
      case 2:
        return '0-15 days unhealthy, 230ml required';
      case 3:
        return '16-30 days healthy, 250ml required';
      case 4:
        return '16-30 days unhealthy, 300ml required';
      case 5:
        return '31+ days healthy, 400ml required';
      case 6:
        return '31+ days unhealthy, 450ml required';
      default:
        return 'Unknown';
    }
  }

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
            Text(
              _getPredictionDescription(prediction),
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
