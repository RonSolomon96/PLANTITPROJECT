import 'package:flutter/material.dart';
import 'package:plantit/screens/homeInfoCard/body.dart';

class DetailsScreen extends StatelessWidget {
      dynamic cPlant;


    DetailsScreen({Key? key, required this.cPlant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Body(
        cPlant: cPlant,
      ),
    );
  }
}