import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'infoCard/details_screen.dart';

class ChoosePlantScreen extends StatefulWidget {
  final String light;
  final String moisture;
  final String temperature;
  final List plantCollection ;
  final String userEmail;

  const ChoosePlantScreen({
    Key? key,
    required this.light,
    required this.moisture,
    required this.temperature,
    required this.plantCollection,
    required this.userEmail
  }) : super(key: key);

  @override
  _ChoosePlantScreenState createState() => _ChoosePlantScreenState();
}

class _ChoosePlantScreenState extends State<ChoosePlantScreen> {
  TextEditingController searchController = TextEditingController();
  late List searchResult;

  @override
  void initState() {
    super.initState();
    searchResult = widget.plantCollection;
    searchController.addListener(() {
      setState(() {
        String query = searchController.text.toLowerCase();
        searchResult = widget.plantCollection.where((plant) {
          String plantName = plant['Common_name'].toLowerCase();
          return plantName.contains(query);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Screen'),
        backgroundColor: const Color(0xff07a36f),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search plants',
                hintText: 'Search plants',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResult.length, // Number of plants to display
              itemBuilder: (BuildContext context, int index) {
                var cPlant = searchResult[index];
                var name = searchResult[index]["Common_name"];
                var des;
                if(name == "African Violets"){
                  des = searchResult[index]["Description"];
                }else{
                  searchResult[index]["Description"]="hi";
                }

                return GestureDetector(
                    onTap: () {
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/5.ico',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          cPlant["Common_name"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Description of plant ${index + 1}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  c_plant: cPlant,
                              userEmail: widget.userEmail,
                            ),
                          ),
                        );

                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}