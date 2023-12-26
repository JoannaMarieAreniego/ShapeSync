// converter_screen.dart
import 'package:flutter/material.dart';

class ConverterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Unit Converter'),
        backgroundColor: Color.fromARGB(255, 68, 194, 133),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/dash_back.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildConverterButton(context, 'Meters to Centimeters', () {
                      _showConversionResult(context, 'Meters to Centimeters', 100.0);
                    }),
                    const SizedBox(height: 10,),
                    _buildConverterButton(context, 'Meters to Inches', () {
                      _showConversionResult(context, 'Meters to Inches', 39.3701);
                    }),
                    const SizedBox(height: 10,),
                    _buildConverterButton(context, 'Inches to Centimeters', () {
                      _showConversionResult(context, 'Inches to Centimeters', 2.54);
                    }),
                    const SizedBox(height: 10,),
                    _buildConverterButton(context, 'Centimeters to Inches', () {
                      _showConversionResult(context, 'Centimeters to Inches', 0.393701);
                    }),
                    const SizedBox(height: 10,),
                    _buildConverterButton(context, 'Kilograms to Pounds', () {
                      _showConversionResult(context, 'Kilograms to Pounds', 2.20462);
                    }),
                    const SizedBox(height: 10,),
                    _buildConverterButton(context, 'Pounds to Kilograms', () {
                      _showConversionResult(context, 'Pounds to Kilograms', 0.453592);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConverterButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 222, 201, 230), // Adjust button color
          onPrimary: Colors.black, // Adjust text color
          elevation: 8.0,
          padding: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  void _showConversionResult(BuildContext context, String conversion, double factor) {
    TextEditingController inputValueController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conversion: $conversion'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter the value for conversion:'),
              TextField(
                controller: inputValueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          actions: [
            _buildDialogButton('Cancel', () {
              Navigator.of(context).pop();
            }),
            _buildDialogButton('Convert', () {
              double inputValue = double.tryParse(inputValueController.text) ?? 0.0;
              double result = inputValue * factor;

              Navigator.of(context).pop();
              _showResultDialog(context, conversion, inputValue, result);
            }),
          ],
          backgroundColor: Color.fromARGB(255, 231, 247, 225),
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, String conversion, double inputValue, double result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conversion Result: $conversion'),
          content: Text('$inputValue is equal to $result'),
          actions: [
            _buildDialogButton('OK', () {
              Navigator.of(context).pop();
            }),
          ],
          backgroundColor: Color.fromARGB(255, 231, 247, 225),
        );
      },
    );
  }

  Widget _buildDialogButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(fontSize: 18, color: Color(0xFF6b1983))),
    );
  }
}
