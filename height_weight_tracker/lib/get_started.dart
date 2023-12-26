// get_started.dart
import 'package:flutter/material.dart';
import 'package:height_weight_tracker/screens/dashboard.dart';

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShapeSync'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 60, 190, 127),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dash_back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 4200,
                child: Image.asset(
                  'assets/images/hlogo.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Welcome to ShapeSync',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Track your height and weight to monitor your BMI.',
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
