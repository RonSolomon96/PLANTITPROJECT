import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';


class CarePlanHistoryScreen extends StatefulWidget {
  final String userEmail;
  final String plant;

  const CarePlanHistoryScreen({
    Key? key,
    required this.plant,
    required this.userEmail,
  }) : super(key: key);

  @override
  _CarePlanHistoryScreenState createState() => _CarePlanHistoryScreenState();
}

class _CarePlanHistoryScreenState extends State<CarePlanHistoryScreen> {
  List<dynamic> _carePlans = [];

  @override
  void initState() {
    super.initState();
    // Load data from database or API
    _loadCarePlans();
  }

  void _loadCarePlans() async {
    final response = await http.get(Uri.parse('$serverUrl/history/${widget.userEmail}/${widget.plant}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _carePlans = data;
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userEmail),
      ),
      body: _carePlans.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _carePlans.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _carePlans[index]["date"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                  'assets/images/5.ico',
                    height: 200,
                    width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Disease: ${_carePlans[index]["disease"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Care plan: ${_carePlans[index]["care plan"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
