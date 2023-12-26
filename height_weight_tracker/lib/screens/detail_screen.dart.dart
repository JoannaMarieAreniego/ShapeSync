import 'package:flutter/material.dart';
import 'package:height_weight_tracker/helpers/db_helper.dart';
import 'package:height_weight_tracker/screens/edit_data.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String idKey;

  DetailsScreen({required this.data, required this.idKey});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic> _editedData = {};

  @override
  void initState() {
    super.initState();
    _editedData = Map.from(widget.data);
  }

  void _deleteData(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this data?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final id = widget.data[widget.idKey];
                if (id != null) {
                  await DbHelper.deleteData(id);
                  Navigator.pop(context);
                } else {
                  print('Error: Unable to delete data. ID is null.');
                }
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
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

 void _editData(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EditDataScreen(data: _editedData)),
  );

  if (result != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data updated successfully')));
    setState(() {
      _editedData['heightValue'] = result['heightValue'];
      _editedData['weightValue'] = result['weightValue'];

      // Calculate new BMI and category
      double newBMI = DbHelper.calculateBMI(_editedData['heightValue'], _editedData['weightValue']);
      _editedData['bmiValue'] = newBMI;
      _editedData['category'] = _getBMICategory(newBMI);

      _editedData['bmidate'] = result['bmidate'];
    });
  }
}


  @override
  Widget build(BuildContext context) {
    String bmidate = _editedData['bmidate'] != null ? _editedData['bmidate'] : 'N/A';
    String category = _editedData['category'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 60, 190, 127),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade100, Colors.purple.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildDetailRow('Date:', _formatDate(bmidate)),
                                _buildDetailRow('Height:', '${_editedData['heightValue']}'),
                                _buildDetailRow('Weight:', '${_editedData['weightValue']}'),
                                _buildDetailRow('BMI:', '${_editedData['bmiValue'].toStringAsFixed(2)}'),
                                _buildDetailRow('Category:', category),
                                SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _deleteData(context),
                                      icon: Icon(Icons.delete, color: Colors.black,),
                                      label: Text('Delete', style: TextStyle(color: Colors.black)),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromARGB(255, 0, 190, 248),
                                        textStyle: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    ElevatedButton.icon(
                                      onPressed: () => _editData(context),
                                      icon: Icon(Icons.edit, color: Colors.black),
                                      label: Text('Edit', style: TextStyle(color: Colors.black)),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(248, 168, 48, 1),
                                        textStyle: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 4.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(8.0),
          child: Text(value, style: TextStyle(fontSize: 16, color: Colors.black)), 
        ),
      ],
    ),
  );
}


  String _formatDate(String iso8601Date) {
    final dateTime = DateTime.parse(iso8601Date);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}
