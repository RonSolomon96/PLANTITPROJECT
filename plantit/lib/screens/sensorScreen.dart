import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'choosePlantScreen.dart';
import 'homeScreen.dart';


class SensorScreen extends StatefulWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}


class _SensorScreenState extends State<SensorScreen> {
  String _light = '';
  String _temperature = '';
  String _moisture = '';

  late RawDatagramSocket _socket;

  @override
  void initState() {
    super.initState();
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

          if (messageParts[0] == 'light') {
            setState(() {
              _light = messageParts[1];
            });
          } else if (messageParts[0] == 'temperature') {
            setState(() {
              _temperature = messageParts[1];
            });
          } else if (messageParts[0] == 'moisture') {
            setState(() {
              _moisture = messageParts[1];
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.green.shade800,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Light: $_light',
                style: TextStyle(color: Colors.green.shade200, fontSize: 24),
              ),
              Text(
                'Temperature: $_temperature',
                style: TextStyle(color: Colors.green.shade200, fontSize: 24),
              ),
              Text(
                'Moisture: $_moisture',
                style: TextStyle(color: Colors.green.shade200, fontSize: 24),
              ),

                  FloatingActionButton(
                    onPressed: () {
                      print("hi");
                      _setupSocket();
                    },
                    backgroundColor: Colors.green.shade900, // call _setupSocket when the button is pressed
                    child: const Icon(Icons.play_arrow),
                  )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChoosePlantScreen(
                light: 100,
                moisture: 50,
                temperature: 25,)));
        },
        backgroundColor: Colors.green.shade900, // call _setupSocket when the button is pressed
        child: const Text("Send"),
      ),
    );

  }

  @override
  void dispose() {
    _socket.close();
    super.dispose();
  }
}