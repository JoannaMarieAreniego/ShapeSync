import 'package:flutter/material.dart';
import 'package:height_weight_tracker/helpers/db_helper.dart';

class InsertData extends StatefulWidget {
  @override
  _InsertDataState createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  double? bmi;
  String? bmiCategory;

  bool isGenerateButtonClicked = false;

  void _calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;

    if (height > 0 && weight > 0) {
      double heightInMeters = height / 100;
      double bmiValue = weight / (heightInMeters * heightInMeters);

      setState(() {
        bmi = bmiValue;
        bmiCategory = _getBMICategory(bmiValue);
        isGenerateButtonClicked = true;
      });
    } else {
      setState(() {
        bmi = null;
        bmiCategory = null;
        isGenerateButtonClicked = false;
      });
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  void _saveData() async {
    if (!isGenerateButtonClicked) {
      print('Error: BMI calculation not done.');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Data Entry'),
          content: Text('Do you want to add this data?\nBMI: ${bmi?.toStringAsFixed(2)}\nCategory: $bmiCategory'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                double heightValue = double.tryParse(heightController.text) ?? 0.0;
                double weightValue = double.tryParse(weightController.text) ?? 0.0;

                await DbHelper.insertData(heightValue, weightValue, bmi ?? 0.0, bmiCategory ?? '');
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Data'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.yellow.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField('Height (cm)', heightController),
              SizedBox(height: 16.0),
              _buildTextField('Weight (kg)', weightController),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _calculateBMI,
                child: Text('Generate BMI'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFf3d4ff),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16.0),
              if (bmi != null)
                Card(
                  color: Colors.blue.shade50,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'BMI: ${bmi?.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Category: $bmiCategory',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              Spacer(),
              ElevatedButton(
                onPressed: isGenerateButtonClicked ? _saveData : null,
                child: Text('Save Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      ),
    );
  }
}
