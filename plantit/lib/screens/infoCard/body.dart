import 'package:flutter/material.dart';
import 'package:plantit/screens/infoCard/add_to_garden_button.dart';
import 'package:plantit/screens/infoCard/image_and_icons.dart';
import 'package:plantit/screens/infoCard/product_description.dart';
import 'package:plantit/screens/infoCard/title.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Body extends StatefulWidget {
   var cPlant;
   final String userEmail;
   final Function render;

   Body({Key? key, required this.userEmail,required this.cPlant, required this.render}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String name = widget.cPlant["Common_name"];
    String Bname = widget.cPlant["Botanical Name"];
    String des = widget.cPlant["Description"];
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageAndIcons(size: size ,current: widget.cPlant),
          TitleName(
            name: name,
            bName: Bname
          ),
          AddToGardenButton(size: size, cPlnat: widget.cPlant,userEmail: widget.userEmail, render: widget.render,),
          const SizedBox(
            height: 16,
          ),
          ProductDescription(size: size ,des:des),
        ],
      ),
    );
  }
}
