import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'infoCard/details_screen.dart';

class InfoScreen extends StatefulWidget {
  final List plantCollection;
  final String userEmail;
  final String title;
  final String text;
  final String hinttext;

  const InfoScreen({
    Key? key,
    required this.plantCollection,
    required this.userEmail,
    required this.title,
    required this.text,
    required this.hinttext,
  }) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late List filteredPlants;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPlants = widget.plantCollection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Center(child: Text(widget.title)),
        backgroundColor: const Color(0xff07a36f),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
      ),
      body: Container(
        decoration:  const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: widget.text,
                  hintText: widget.hinttext,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    filteredPlants = widget.plantCollection.where((plant) =>
                        plant["Common_name"]
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase())).toList();
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPlants.length, // Number of plants to display
                itemBuilder: (BuildContext context, int index) {
                  var name = filteredPlants[index]["Common_name"];

                  var currentPlant = filteredPlants[index];
                  var des = filteredPlants[index]["Description"];
                  var img1  = filteredPlants[index]["Image_url"];
                  img1 ??= 'assets/images/5.ico';


                  return GestureDetector(
                      onTap: () {},
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
                              child: Image.network(
                               img1,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            currentPlant["Botanical Name"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                      c_plant: currentPlant,
                                      userEmail: widget.userEmail),
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
      ),
    );
  }
}
