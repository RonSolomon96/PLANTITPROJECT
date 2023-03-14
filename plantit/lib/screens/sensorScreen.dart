import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'choosePlantScreen.dart';
import 'homeScreen.dart';


class SensorScreen extends StatefulWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}


class _SensorScreenState extends State<SensorScreen> {
  String _light = '2';
  String _temperature = '2';
  String _moisture = '2';

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
  //send data to server in order to login
  Future<List<dynamic>> fetchPlants() async {
    final response = await http.get(Uri.parse('http://10.100.102.4:5000/plants'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON response
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load plants');
    }
  }








  //send data to server in order to login
  Future<List<dynamic>> fetchPlants2(String l,String t,String m) async {
    final response = await http.get(Uri.parse('http://10.100.102.4:5000/plants'
        '/$l/$t/$m'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON response
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load plants');
    }
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

        onPressed: () async {
          var p;
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
                temperature: _temperature, plantCollection: p)));
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