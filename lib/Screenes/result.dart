import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ResultPage extends StatefulWidget {
  final int prediction;
  final String imagePath;

  const ResultPage({Key? key, required this.prediction, required this.imagePath})
      : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late DatabaseReference _temperatureRef;
  late DatabaseReference _humidityRef;
  late DatabaseReference _soilMoistureRef;

  String soilMoistureValue = 'Fetching...';
  String temperatureValue = 'Fetching...';
  String humidityValue = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _temperatureRef = FirebaseDatabase.instance.reference().child('Temperature');
    _humidityRef = FirebaseDatabase.instance.reference().child('Humidity');
    _soilMoistureRef = FirebaseDatabase.instance.reference().child('SoilMoisture');

    _temperatureRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          temperatureValue = event.snapshot.value.toString();
        });
      }
    });

    _humidityRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          humidityValue = event.snapshot.value.toString();
        });
      }
    });

    _soilMoistureRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          soilMoistureValue = event.snapshot.value.toString();
        });
      }
    });
  }

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
        backgroundColor: Colors.black,
        title: Text(
          'Result',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.file(
                File(widget.imagePath),
                width: 400,
                height: 400,
              ),
              SizedBox(height: 20),
              Text(
                _getPredictionDescription(widget.prediction),
                style: TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildSensorCard("Temperature (°C)", Icons.thermostat, temperatureValue),
              SizedBox(height: 20),
              _buildSensorCard("Humidity", Icons.opacity, humidityValue),
              SizedBox(height: 20),
              _buildSensorCard("Soil Moisture", Icons.waves, soilMoistureValue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorCard(String title, IconData iconData, String value) {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
