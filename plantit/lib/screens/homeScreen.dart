import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:plantit/screens/homeInfoCard/details_screen.dart';
import 'package:plantit/screens/infoScreen.dart';
import 'package:plantit/screens/values/constants.dart';
import 'package:plantit/main.dart';

class MyGardenScreen extends StatefulWidget {
  final String userEmail;
  final List plantCollection;

  const MyGardenScreen({
    Key? key,
    required this.plantCollection,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

class _MyGardenScreenState extends State<MyGardenScreen> {
  String? _username;
  List<dynamic>? _userPlants;
  List<dynamic>? _filteredPlants;

  final TextEditingController _searchController = TextEditingController();

  bool _isLoadingUser = true; // Add a boolean to keep track of loading state
  bool _isLoadingUserPlants = true;

  @override
  void initState() {
    super.initState();
    print("object");
    _fetchUserData();
    _fetchUserPlantsData();
  }

  void updateScreen() {
    setState(() {
      _isLoadingUser = true;
      _isLoadingUserPlants = true;
      _fetchUserData();
      _fetchUserPlantsData();
    });
  }


  Future<void> _fetchUserData() async {
    final response =
    await http.get(Uri.parse('$serverUrl/users/${widget.userEmail}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _username = data['username'];
        _isLoadingUser = false; // Set loading state to false when data is fetched
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _fetchUserPlantsData() async {
    final response =
    await http.get(Uri.parse('$serverUrl/plants/${widget.userEmail}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _userPlants = data;
        _filteredPlants = _userPlants;
        _isLoadingUserPlants = false; // Set loading state to false when data is fetched
      });
    } else {
      throw Exception('Failed to load user plants data');
    }
  }


  void _filterPlants(String query) {
    setState(() {
      _filteredPlants = _userPlants
          ?.where((plant) => plant["nickname"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: _isLoadingUser || _isLoadingUserPlants
            ? const Center(child: CircularProgressIndicator()) // Show CircularProgressIndicator when loading
            : Container(
          decoration:  const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
              child: Column(
                  children: <Widget> [
                    Container(
                      margin: const EdgeInsets.only(bottom: kDefaultPadding),
                      height: size.height * 0.25,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(
                              left: kDefaultPadding,
                              right: kDefaultPadding,
                              bottom: kDefaultPadding,
                            ),
                            height: size.height * 0.25 - 27,
                            decoration: const BoxDecoration(
                                color: Color(0xff07a36f),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(36),
                                    bottomRight: Radius.circular(36)
                                )
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Hey $_username,\n  Welcome to PlantIt!',
                                  style: const TextStyle(
                                      color: Colors.white,fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 1
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 30,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Are you sure you want to log out?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('No'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Yes'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Log Out',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                              height: 54,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0,10),
                                      blurRadius: 50,
                                      color: kPrimaryColor.withOpacity(0.23),
                                    ),
                                  ]
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: _filterPlants,
                                decoration: const InputDecoration(
                                  hintText: "Search here...",
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  suffixIcon: Icon(
                                    Icons.search_outlined,),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10) ,
                          child: Text(
                            "My Garden :",
                            style: TextStyle(
                                color: Colors.green.shade300,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Expanded(
                      child: _userPlants!.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.local_florist,
                              size: 50.0,
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'No plants yet',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        itemCount: _filteredPlants!.length,
                        itemBuilder: (context, index) {
                          String wl = "Current water level: not checked yet";
                          Color c = Colors.indigo;
                          if(_filteredPlants![index]["Water level"] != ""){
                            int waterLevel = int.parse(_filteredPlants![index]["Water level"]);
                            int waterLevelNedded = int.parse(_filteredPlants![index]["Water"]);
                            if(waterLevel > waterLevelNedded) {
                              wl = "Current water level: High";
                              c = Colors.red;
                            } else if (waterLevel == waterLevelNedded) {
                              wl = "Current water level: Perfect";
                              c = Colors.green;
                            } else {
                              wl = "Current water level: Low";
                              c = Colors.orange;
                            }
                          }
                          return Card(
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
                                  _filteredPlants![index]["Image_url"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              _filteredPlants![index]["nickname"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _filteredPlants![index]["Common_name"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  wl,
                                  style: TextStyle(color: c),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                               Navigator.push(context,
                                   MaterialPageRoute(builder: (context) => DetailsScreen(
                                       cPlant : _filteredPlants![index],
                                       userEmail: widget.userEmail, render: updateScreen)));
                              },
                              icon: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );},
                      ),
                    ),
                  ]
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  InfoScreen(title: "Choose plant to add",
                    text: "Search for plant to add...",
                    hinttext: "Search",
                    userEmail: widget.userEmail,
                    plantCollection: widget.plantCollection,)));
        },
        backgroundColor: Color.fromARGB(255, 7, 163, 111),
        child: Icon(Icons.add),
      ),

    );
  }
}


