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
import '../../main.dart';

class Body extends StatefulWidget {
   var cPlant;
   final String userEmail;
   Function render;

   Body({Key? key,required this.userEmail, required this.cPlant, required this.render}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File? _image;
  bool waterBtn = false;

  // add image to history
  Future<void> _getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      // Create a multipart request using http.MultipartRequest
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('$serverUrl/addToHistory?user=${widget.userEmail}&plant=${widget.cPlant["nickname"]}')
      );

      // Add the image file to the request
      var imageFile = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(imageFile);

      // Add the other form data to the request
      request.fields['date'] = DateFormat.yMd().add_jm().format(DateTime.now());

      // Send the request and wait for the response
      var response = await request.send();
      if (response.statusCode == 200) {
        // Do something with the response
      }
    }

    setState(() {
      _image = File(image!.path);
    });
  }


  Future<bool> _showTrashDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete this plant?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await delete();
              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
              widget.render();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  // the functionality for handling the water level
  Future<void> handleWaterLevel() async {
    waterBtn = false;
    //update the db that the user handled the water level
    await http.post(Uri.parse('$serverUrl/updateWaterLevel?user=${widget.userEmail}&plant=${widget.cPlant["nickname"]}'));
    //render home screen
    widget.render();
    setState(() {
      widget.cPlant["Water level"] = "handled";
    });
  }

  //delete plant
  Future<void> delete() async {
    await http.delete(Uri.parse('$serverUrl/deletePlant?user=${widget.userEmail}&plant=${widget.cPlant["nickname"]}'));
  }

  // popup screen to choose photo. take a photo or choose from gallery
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
    String wl = "Current water level: not checked yet";
    String treat = "";
    Color c = Colors.indigo;
    waterBtn = false;
    if(widget.cPlant["Water level"] != "") {
      if(widget.cPlant["Water level"] == "handled") {
        wl = "Water level was handled";
        c = Colors.lightGreen;
      }
      else {
        int waterLevel = int.parse(widget.cPlant["Water level"]);
        int waterLevelNedded = int.parse(widget.cPlant["Water"]);
        if (waterLevel > waterLevelNedded) {
          wl = "Current water level: High";
          treat =
          "Put ${widget.cPlant["nickname"]} under the sun, let it dry a little";
          c = Colors.red;
          waterBtn = true;
        } else if (waterLevel == waterLevelNedded) {
          wl = "Current water level: Perfect";
          treat = "Keep going!";
          c = Colors.green;
        } else {
          wl = "Current water level: Low";
          treat = "Add 1 cup of water to ${widget.cPlant["nickname"]}";
          c = Colors.orange;
          waterBtn = true;
        }
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageAndIcons(size: size ,current: widget.cPlant),
          Text(
            wl,
            style: TextStyle(color: c, fontSize: 25),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            treat,
            style: TextStyle(color: c, fontSize: 20),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if(waterBtn)
            ElevatedButton(
            child: const Text('Handled? press here'),
            onPressed: handleWaterLevel,
            style: ElevatedButton.styleFrom(
              primary: ColorsPalette.kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
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
              ElevatedButton.icon(
                icon: Icon(Icons.delete_outlined),
                label: Text('Delete Plant'),
                onPressed: _showTrashDialog,
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
