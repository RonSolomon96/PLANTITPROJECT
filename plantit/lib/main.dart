import 'package:flutter/material.dart';
import 'package:plantit/screens/values/constants.dart';
import 'package:plantit/screens/loginScreen.dart';

String serverUrl = 'http://192.168.53.102:5000';

void main() {
  runApp(const MyApp());
}

/// This widget is the root of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});


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
      //start with login screen
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
