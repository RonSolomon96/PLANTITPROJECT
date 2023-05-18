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
  String? _sensornumber;
  var _plantsdata ;
  var _pnames = [];
  var _sensorsdata ;
  var _snames = [];

  final TextEditingController _controller = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();


  Future<void> fetchData() async {
    final response = await http.get(Uri.parse("$serverUrl/plants/$userEmail" ));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _plantsdata = jsonData;
      var p;
      for (p in _plantsdata) {
        _pnames.add(p["nickname"]);
      }
    }else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchSensors() async {
    final response = await http.get(Uri.parse("$serverUrl/sensors" ));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _sensorsdata = jsonData;
      var s;
      for (s in _sensorsdata) {
        _snames.add(s["sensornumber"]);
      }
    }else {
      throw Exception('Failed to load data');
    }
  }
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
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: _formKey1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Choose a nickname for your plant",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a nickname';
                                    }
                                    for(var p1 in _pnames) {
                                      print(p1);
                                      if (value == p1) {
                                        return 'Nickname already taken';
                                      }
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _nickname = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Form(
                            key: _formKey2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Enter the sensor serial number",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the sensor serial number';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Sensor serial number must be a valid integer';
                                    }
                                    print(_sensorsdata);
                                    print(_snames);
                                    for(var s1 in _snames) {
                                      if (value == s1) {
                                        return 'Sensor already in use';
                                      }
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _sensornumber = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
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
                            await fetchData();
                            await fetchSensors();


                            if (_formKey1.currentState != null && _formKey2.currentState != null &&
                                _formKey1.currentState!.validate() && _formKey2.currentState!.validate()) {
                              _formKey1.currentState?.save();
                              _formKey2.currentState?.save();
                              final nickname = _nickname;
                              final sensornumber = _sensornumber;
                              print(sensornumber);

                              Map<String, dynamic> stringMap = cPlnat as Map<String, dynamic>;
                              cPlnat["nickname"]=nickname;
                              // do something with the nickname, e.g. save it to a database
                              print(userEmail);
                              final response = await http.post(Uri.parse("$serverUrl/addToGarden?user=$userEmail&&sensornum=$sensornumber" ),headers: <String, String>{
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