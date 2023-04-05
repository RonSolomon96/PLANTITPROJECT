import 'dart:convert';

import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantit/screens/values/colors_palette.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
class AddToGardenButton extends StatelessWidget {
  var cPlnat;
  final String userEmail;

   AddToGardenButton({
     Key? key,
     required this.userEmail,
     required this.size,
     required this.cPlnat,
  }) : super(key: key);

  final Size size;
   String? _nickname;
   final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * 0.6,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Enter a nickname for your plant"),
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a nickname';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _nickname = value;
                          },
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('CANCEL'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: Text('SAVE'),
                          onPressed: () async {
                            print("orttttttt");
                            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              final nickname = _nickname;
                              Map<String, dynamic> stringMap = cPlnat as Map<String, dynamic>;
                              cPlnat["nickname"]=nickname;
                              // do something with the nickname, e.g. save it to a database
                              print(userEmail);
                              final response = await http.post(Uri.parse("$serverUrl/addToGarden?user=$userEmail" ),headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                                  body: jsonEncode(stringMap)
                            );
                              if (response.statusCode == 200) {
                                // Successfully saved nickname to database
                              } else {
                                // Failed to save nickname to database
                              }
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                primary: ColorsPalette.kPrimaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: const Text(
                "Add to my garden",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}