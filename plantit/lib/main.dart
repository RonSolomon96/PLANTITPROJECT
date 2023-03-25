import 'package:flutter/material.dart';
import 'package:plantit/screens/infoCard/details_screen.dart';
import 'package:plantit/screens/scanScreen.dart';
import 'package:plantit/screens/sensorScreen.dart';
import 'package:plantit/screens/values/constants.dart';
import 'package:plantit/screens/loginScreen.dart';

String serverUrl = 'http://10.100.102.4:5000';

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
        scaffoldBackgroundColor: kBackgroundColor,
        primarySwatch: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
      home: const SensorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
