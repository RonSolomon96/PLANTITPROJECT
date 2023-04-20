import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantit/screens/infoCard/add_to_garden_button.dart';
import 'package:plantit/screens/infoCard/image_and_icons.dart';
import 'package:plantit/screens/infoCard/product_description.dart';
import 'package:plantit/screens/infoCard/title.dart';
import 'package:plantit/screens/values/colors_palette.dart';
import 'package:plantit/screens/values/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Body extends StatefulWidget {
   var cPlant;
   final String userEmail;

   Body({Key? key, required this.userEmail,required this.cPlant}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File? _image;


  Future<void> _getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
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
          AddToGardenButton(size: size, cPlnat: widget.cPlant,userEmail: widget.userEmail),
          const SizedBox(
            height: 16,
          ),
          ProductDescription(size: size ,des:des),
        ],
      ),
    );
  }
}
