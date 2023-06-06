import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../main.dart';
import 'choosePlantScreen.dart';

class SensorScreen extends StatefulWidget {
  final String userEmail;
  final Function render;

  const SensorScreen({Key? key, required this.userEmail, required this.render}) : super(key: key);

  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimating = false;
  bool _isComplete = false;
  String _light = '2';
  String _temperature = '2';
  String _moisture = '2';

  late RawDatagramSocket _socket;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isComplete = true;
        });
      }
    });
  }

  void _setupSocket() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 12345);
    print('Socket is open and bound to ${_socket.address.address}:${_socket.port}');
    _socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket.receive();
        if (datagram != null) {
          final message = utf8.decode(datagram.data);
          final messageParts = message.split(':');

          if (messageParts[0] == 'lightRead') {

              _light = messageParts[1];
              if (_light != '') {
                int num = int.parse(_light);
                num = num ~/ 300;
                if (num == 0) {
                  setState(() {
                    _light = '1';
                  });
                }
                else {
                  setState(() {
                     num++;
                    _light = num.toString();
                  });
                }
              }
              print(_light);
          }
          if (messageParts[2] == 'humidity') {

              _moisture = messageParts[3];
              if (_moisture != '') {
                double a = double.parse(_moisture);
                int num = a.round();
                print("themoistis : ");
                print(_moisture);
                if (num < 24) {
                  setState(() {
                    _moisture = '1';
                  });
                }
                else  if (num < 50) {
                  setState(() {
                    _moisture = '2';
                  });
                }
                else  if (num > 49) {
                  setState(() {
                    _moisture = '3';
                  });
                }
              }
          }

          if (messageParts[4] == 'temperature') {
            _temperature = messageParts[5];
            if (_temperature != '') {
              double a = double.parse(_temperature);
              int num = a.round();
              if (num < 18) {
                setState(() {
                  _temperature = '1';
                });
              }
              else  if (num < 23) {
                setState(() {
                  _temperature = '2';
                });
              }
              else  if (num > 23) {
                setState(() {
                  _temperature = '3';
                });
              }
            }
          }
        }
      }
    });

  }

  Future<List<dynamic>> fetchPlants() async {
    print("noall");
    final response = await http.get(Uri.parse('$serverUrl/plants'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON response
      print(response.body);
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load plants');
    }
  }


  //send data to server in order to login
  Future<List<dynamic>> fetchPlants2(String l,String t,String m) async {
    print("noa");
    final response = await http.get(Uri.parse('$serverUrl/plants/$l/$t/$m'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON response
      final data = jsonDecode(response.body);
      return List<dynamic>.from(data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load plants');
    }
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    setState(() {
      _isAnimating = true;
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Sensors')),
        backgroundColor: const Color(0xff07a36f),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration:  const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _startAnimation();
                  print("hi");
                  _setupSocket();
                },
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isAnimating
                        ? _isComplete
                        ? Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green.shade600,
                    )
                        : SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green.shade600),
                      ),
                    )
                        : Icon(
                      Icons.play_arrow,
                      size: 80,
                      color: Colors.green.shade600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              _isComplete
                  ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: ()  async {
                  var p;
                  _socket.close();
                  if (_light != '') {
                    p = await fetchPlants2(_light, _temperature, _moisture);
                  }
                  else{
                    p = await fetchPlants();
                  }

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  ChoosePlantScreen(
                          light: _light,
                          moisture:_moisture ,
                          temperature: _temperature,
                          plantCollection: p, userEmail: widget.userEmail, render: widget.render)));
                  setState(() {
                    _isComplete = false;
                    _isAnimating = false;
                  });
                },
                // Add code here to send the data

                child: const Text(
                  'Send',
                  style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
