// dashboard.dart
import 'package:flutter/material.dart';
import 'package:height_weight_tracker/helpers/db_helper.dart';
import 'package:height_weight_tracker/screens/converter.dart';
import 'package:height_weight_tracker/screens/detail_screen.dart.dart';
import 'package:height_weight_tracker/screens/insert_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Height and Weight Tracker'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 60, 190, 127),
         actions: [
          IconButton(
            icon: Icon(Icons.swap_horizontal_circle, color: Colors.black,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConverterScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/dash_back.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: DbHelper.getDataPreview(),
            builder: (context, index) {
              if (!index.hasData || index.data!.isEmpty) {
                return Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
              } else {
                List<Map<String, dynamic>> dataList = List.from(index.data!);
                dataList.sort((a, b) => DateTime.parse(b['bmidate']).compareTo(DateTime.parse(a['bmidate'])));
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index];
                      final heightDate = _formatDate(data['bmidate']);
                      return Card(
                        color: Color(0xFFf3d4ff),
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date: $heightDate', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple)),
                              Text('Height: ${data['heightValue']}', style: const TextStyle(color: Colors.black)),
                              Text('Weight: ${data['weightValue']}', style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(data: data, idKey: 'bmiid'),
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InsertData()),
          );
          setState(() {});
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFe0ffd4),
      ),
    );
  }

  String _formatDate(String? iso8601Date) {
    if (iso8601Date == null) return 'No Date';
    final dateTime = DateTime.parse(iso8601Date);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}
