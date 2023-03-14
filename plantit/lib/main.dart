import 'package:flutter/material.dart';
import 'package:plantit/screens/homeScreen.dart';
import 'package:plantit/screens/loginScreen.dart';
import 'package:plantit/screens/sensorScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PLANTIT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SensorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
