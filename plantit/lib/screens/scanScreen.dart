import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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
          title: Text("Select image source"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Row(
                    children: [
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
                Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  child: Row(
                    children: [
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.qr_code),
              label: Text('Scan'),
              onPressed: _showOptionsDialog,
            ),
          ],
        ),
      ),
    );
  }
}
