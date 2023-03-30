import 'package:flutter/material.dart';
import 'package:plantit/screens/infoCard/body.dart';

class DetailsScreen extends StatelessWidget {
   final String plantName;
   final String description;

   const DetailsScreen({Key? key, required this.plantName, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Body(
          pName: plantName, des: description,
      ),
    );
  }
}