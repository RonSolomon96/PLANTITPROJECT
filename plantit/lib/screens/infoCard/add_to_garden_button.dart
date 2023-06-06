import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plantit/screens/values/colors_palette.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';

class AddToGardenButton extends StatelessWidget {
  var cPlnat;
  final String userEmail;
  final Function render;

  AddToGardenButton({
    Key? key,
    required this.userEmail,
    required this.size,
    required this.cPlnat,
    required this.render,
  }) : super(key: key);

  final Size size;
  String? _nickname;
  String? _sensornumber;
  var _plantsdata ;
  var _pnames = [];
  var _sensorsdata ;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();


  // get the user plants (in order to have a list of all plants nicknames - this way we know which nickname is valid)
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

  // get the water sensors (in order to check which sensor number is valid)
  Future<void> fetchSensors() async {
    final response = await http.get(Uri.parse("$serverUrl/sensors" ));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _sensorsdata = jsonData;
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
                                const Text(
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
                                const Text(
                                  "Enter the sensor serial number",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the sensor serial number';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Invalid sensor serial number';
                                    }
                                    print(_sensorsdata);
                                    for(var s in _sensorsdata) {
                                      if (value == s['sensornumber'] && s['user'] != userEmail) {
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
                            // if validations pass
                            if (_formKey1.currentState != null && _formKey2.currentState != null &&
                                _formKey1.currentState!.validate() && _formKey2.currentState!.validate()) {
                              _formKey1.currentState?.save();
                              _formKey2.currentState?.save();
                              final nickname = _nickname;
                              final sensornumber = _sensornumber;

                              Map<String, dynamic> stringMap = cPlnat as Map<String, dynamic>;
                              cPlnat["nickname"]=nickname;
                              await http.post(Uri.parse("$serverUrl/addToGarden?user=$userEmail&&sensornum=$sensornumber" ),headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                                  body: jsonEncode(stringMap)
                              );
                              render();
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