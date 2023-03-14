import 'package:flutter/material.dart';

class ChoosePlantScreen extends StatelessWidget {
  final int light;
  final int moisture;
  final int temperature;

  const ChoosePlantScreen({
    Key? key,
    required this.light,
    required this.moisture,
    required this.temperature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Screen'),
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
              itemCount: 10, // Number of plants to display
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text('Plant ${index + 1}'),
                    subtitle: Text('Description of plant ${index + 1}'),
                    leading: CircleAvatar(
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