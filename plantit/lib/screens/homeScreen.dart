import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:plantit/constants.dart';
import 'package:plantit/main.dart';

class MyGardenScreen extends StatefulWidget {
  final String userEmail;

  const MyGardenScreen({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

class _MyGardenScreenState extends State<MyGardenScreen> {
  String? _username;
  List<String>? _userPlants;
  List<String>? _filteredPlants;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final response =
    await http.get(Uri.parse('$serverUrl/users/${widget.userEmail}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _username = data['username'];
        _userPlants = List<String>.from(data['UserPlants']);
        _filteredPlants = _userPlants;
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _filterPlants(String query) {
    setState(() {
      _filteredPlants = _userPlants
          ?.where((plant) => plant.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: <Widget> [
          Container(
            height: size.height * 0.20,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: 36 + kDefaultPadding,
                  ),
                  height: size.height * 0.20 - 27,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36)
                    )
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Welcome, $_username!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                        hintText: "Search",
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
        ]
      ),
    );
  }
}

//
// _username == null || _userPlants == null
// ? const Center(child: CircularProgressIndicator())
// : Column(
// children: [
// Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// 'Welcome, $_username!',
// style: const TextStyle(fontSize: 20, color: Colors.green,),
// ),
// const SizedBox(height: 16),
// TextField(
// controller: _searchController,
// onChanged: _filterPlants,
// decoration: const InputDecoration(
// labelText: 'Search your plants',
// prefixIcon: Icon(Icons.search),
// border: OutlineInputBorder(),
// ),
// ),
// ],
// ),
// ),
// Expanded(
// child: _filteredPlants!.isEmpty
// ? Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: const [
// Icon(
// Icons.local_florist,
// size: 50.0,
// ),
// SizedBox(height: 20.0),
// Text(
// 'No plants yet',
// style: TextStyle(fontSize: 20.0),
// ),
// ],
// ),
// )
//     : ListView.builder(
// itemCount: _filteredPlants!.length,
// itemBuilder: (context, index) => Card(
// child: ListTile(
// title: Text(_filteredPlants![index]),
// onTap: () {
// // Handle plant card tap
// },
// ),
// ),
// ),
// ),
// ],
//),