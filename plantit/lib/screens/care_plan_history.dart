import 'package:flutter/material.dart';

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
    // Code to load care plans goes here
    await Future.delayed(Duration(seconds: 3)); // Example of an async call that takes 3 seconds
    setState(() {
      _carePlans = [        {          "disease": "Heart disease",          "carePlan": "Exercise and diet",          "date": "2022-03-15",          "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",          "image": "https://picsum.photos/id/237/200/300",        },        {          "disease": "Diabetes",          "carePlan": "Insulin therapy",          "date": "2022-02-20",          "description": "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",          "image": "https://picsum.photos/id/238/200/300",        },      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userEmail),
      ),
      body: _carePlans.isEmpty
          ? Center(
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    _carePlans[index]["image"],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Disease: ${_carePlans[index]["disease"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Care plan: ${_carePlans[index]["carePlan"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Date: ${_carePlans[index]["date"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        _carePlans[index]["description"],
                        style: TextStyle(
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
