import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plantit/screens/homeInfoCard/history_button.dart';
import 'package:plantit/screens/homeInfoCard/image_and_icons.dart';
import 'package:plantit/screens/homeInfoCard/product_description.dart';
import 'package:plantit/screens/homeInfoCard/title.dart';
import 'package:plantit/screens/values/colors_palette.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../main.dart';

class Body extends StatefulWidget {
   var cPlant;
   final String userEmail;

   Body({Key? key,required this.userEmail, required this.cPlant}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File? _image;


  Future<void> _getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    // (here we will call function for ml algorithm...)
    //add the info to history
    if(image != null) {
      await http.post(Uri.parse("$serverUrl/addToHistory?user=${widget.userEmail}&plant=${widget.cPlant["nickname"]}" ),headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
          body: jsonEncode(<String, String>{
            "image" : "image",
            "disease" : "the disease",
            "care plan" : "the care plan",
            "date" : DateFormat.yMd().add_jm().format(DateTime.now())
          })
      );
    }
    setState(() {
      _image = File(image!.path);
    });
  }

  Future<void> _showOptionsDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select image source"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.camera_alt),
                      ),
                      Text("Take a photo"),
                    ],
                  ),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.image),
                      ),
                      Text("Choose from gallery"),
                    ],
                  ),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String name = widget.cPlant["nickname"];
    String cName = widget.cPlant["Common_name"];
    String des = widget.cPlant["Description"];
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageAndIcons(size: size ,current: widget.cPlant),
          TitleName(name: name, cName : cName),
          HistoryButton(size: size, cPlnat: widget.cPlant,userEmail: widget.userEmail),
          const SizedBox(
            height: 16,
          ),
          ProductDescription(size: size ,des:des),
          const SizedBox(
            height: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.qr_code),
                label: Text('Scan'),
                onPressed: _showOptionsDialog,
                style: ElevatedButton.styleFrom(
                  primary: ColorsPalette.kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
