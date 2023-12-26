//main.dart
import 'package:flutter/material.dart';
import 'package:height_weight_tracker/get_started.dart';
import 'package:height_weight_tracker/helpers/db_helper.dart';
import 'package:height_weight_tracker/screens/dashboard.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.openDB();
  runApp(HWTracker());
}

class HWTracker extends StatelessWidget {
  const HWTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: DbHelper.hasData(),
        builder: (context, index) {
            final hasData = index.data ?? false;
            return !hasData ? GetStartedScreen() : Dashboard();
        },
      )
    );
  }
}