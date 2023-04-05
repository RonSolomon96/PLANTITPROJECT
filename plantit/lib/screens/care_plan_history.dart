import 'package:flutter/material.dart';

class CarePlanHistoryScreen extends StatefulWidget {
  @override
  _CarePlanHistoryScreenState createState() => _CarePlanHistoryScreenState();
}

class _CarePlanHistoryScreenState extends State<CarePlanHistoryScreen> {
  List<CarePlan> _carePlans = [];

  @override
  void initState() {
    super.initState();
    // Load data from database or API
    _loadCarePlans();
  }

  void _loadCarePlans() async {
    // Code to load care plans goes here
    setState(() {
      _carePlans = [CarePlan(date: '2023-04-01', description: 'Watered plant')];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Care Plan History'),
      ),
      body: ListView.builder(
        itemCount: _carePlans.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_carePlans[index].date),
            subtitle: Text(_carePlans[index].description),
          );
        },
      ),
    );
  }
}

class CarePlan {
  final String date;
  final String description;

  CarePlan({required this.date, required this.description});
}
