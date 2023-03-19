import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChoosePlantScreen extends StatelessWidget {
  final String light;
  final String moisture;
  final String temperature;
  final List plantCollection ;


  const ChoosePlantScreen({
    Key? key,
    required this.light,
    required this.moisture,
    required this.temperature,
    required this.plantCollection,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Screen'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Light: $light',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  'Moisture: $moisture',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  'Temperature: $temperature',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plantCollection.length, // Number of plants to display
              itemBuilder: (BuildContext context, int index) {
                var name = plantCollection[index]["Common_name"];
                return Card(
                  child: ListTile(
                    title: Text('$name'),
                    subtitle: Text('Description of plant ${index + 1}'),
                    leading: CircleAvatar(
                        backgroundColor: Colors.green,
                      child: Text('${index + 1}'),
                    ),
                    onTap: () {
                      // Handle plant card tap
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}