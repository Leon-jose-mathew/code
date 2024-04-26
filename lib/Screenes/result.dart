import 'dart:async';
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
  late DatabaseReference _remainingRef;

  String soilMoistureValue = 'Fetching...';
  String temperatureValue = 'Fetching...';
  String humidityValue = 'Fetching...';
  String remainingWaterValue = 'Fetching...';

  late Timer _timer;
  int _countdown = 5;
  bool _isDispensing = false;

  @override
  void initState() {
    super.initState();
    _temperatureRef = FirebaseDatabase.instance.reference().child('Temperature');
    _humidityRef = FirebaseDatabase.instance.reference().child('Humidity');
    _soilMoistureRef = FirebaseDatabase.instance.reference().child('SoilMoisture');
    _remainingRef = FirebaseDatabase.instance.reference().child('Remaining');

    // Set the default value of Status to 0
    FirebaseDatabase.instance.reference().child('Status').set(0);

    if (widget.prediction != 7) {
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

      _remainingRef.onValue.listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            remainingWaterValue = event.snapshot.value.toString();
            _isDispensing = remainingWaterValue == 'Water is dispensing';
          });
        }
      });

      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer.cancel();
          _isDispensing = true;
          // Update Status only if the prediction is not 7
          if (widget.prediction != 7) {
            FirebaseDatabase.instance.reference().child('Status').set(1); // Update status to 1
          }
        }
      });
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
      case 7:
        return 'Please provide a valid image!';
      default:
        return 'Unknown';
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
            if (widget.prediction != 7) ...[
              SizedBox(height: 20),
              _buildSensorCard("Temperature (°C)", Icons.thermostat, temperatureValue, "°C"),
              SizedBox(height: 20),
              _buildSensorCard("Humidity", Icons.opacity, humidityValue, "%"),
              SizedBox(height: 20),
              _buildSensorCard("Soil Moisture", Icons.waves, soilMoistureValue, "%"),
              SizedBox(height: 20),
              _buildSensorCard("Water need to be dispensed", Icons.water_damage, remainingWaterValue, "ml"),
              SizedBox(height: 20),
              _buildCountdownCard(),
            ] else ...[
              SizedBox(height: 20),
              Icon(
                Icons.error,
                size: 100,
                color: Colors.red, // Change color as needed
              ),
            ],
          ],
        ),
      ),
    ),
  );
}



 Widget _buildSensorCard(String title, IconData iconData, String value, String unit) {
  double numericValue = double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
  return Card(
    color: const Color.fromARGB(255, 0, 0, 0),
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
            numericValue.toStringAsFixed(1) + " $unit", // Display one decimal place
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildCountdownCard() {
    return Card(
      color: _isDispensing ? Color.fromARGB(255, 6, 85, 38) : Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              _isDispensing ? "Water is dispensing..." : "Water starts to dispense in $_countdown seconds",
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
