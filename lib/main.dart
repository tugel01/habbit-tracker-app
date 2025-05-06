import 'package:flutter/material.dart';
import 'package:habbit_tracker/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {

  // initialize hive
  await Hive.initFlutter();

  // open a box
  await Hive.openBox('Habit_Database');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}