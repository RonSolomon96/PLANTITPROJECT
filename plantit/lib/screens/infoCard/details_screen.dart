import 'package:flutter/material.dart';
import 'package:plantit/screens/infoCard/body.dart';

class DetailsScreen extends StatelessWidget {
      var c_plant;
      final String userEmail;
      final Function render;


      DetailsScreen({Key? key, required this.userEmail, required this.c_plant, required this.render}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Body(
          cPlant: c_plant,
          userEmail: userEmail,
          render: render,
      ),
    );
  }
}