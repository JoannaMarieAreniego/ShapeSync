import 'package:flutter/material.dart';
import 'package:height_weight_tracker/helpers/db_helper.dart';

class EditDataScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  EditDataScreen({required this.data});

  @override
  _EditDataScreenState createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    heightController.text = widget.data['heightValue'].toString();
    weightController.text = widget.data['weightValue'].toString();
  }

 void _saveData() async {
  double heightValue = double.tryParse(heightController.text) ?? 0.0;
  double weightValue = double.tryParse(weightController.text) ?? 0.0;

  if (heightValue <= 0 || weightValue <= 0) {
    // Show an error dialog if height or weight is not valid
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Validation Error"),
          content: Text("Please enter valid height and weight values."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  } else {
    // Show a confirmation dialog before saving
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Save"),
          content: Text("Are you sure you want to save and update the data?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                double newBMI = DbHelper.calculateBMI(heightValue, weightValue);
                await DbHelper.updateData(
                  widget.data[DbHelper.colBMIId],
                  heightValue,
                  weightValue,
                  newBMI,
                  widget.data['bmidate'],
                );

                Navigator.pop(context, {
                  'heightValue': heightValue,
                  'weightValue': weightValue,
                  'bmiValue': newBMI,
                  'bmidate': widget.data['bmidate'],
                });
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField('Height (cm)', heightController),
            SizedBox(height: 16.0),
            _buildTextField('Weight (kg)', weightController),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFf3d4ff),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
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
