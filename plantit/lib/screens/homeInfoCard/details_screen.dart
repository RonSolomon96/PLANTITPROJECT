import 'package:flutter/material.dart';
import 'package:plantit/screens/homeInfoCard/body.dart';

class DetailsScreen extends StatelessWidget {
      dynamic cPlant;
      final String userEmail;
      Function render;


    DetailsScreen({Key? key,required this.userEmail, required this.cPlant, required this.render}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Body(
          cPlant: cPlant,
          userEmail: userEmail,
          render : render
      ),
    );
  }
}