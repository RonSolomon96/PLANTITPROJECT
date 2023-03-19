class User {
  String username;
  String mail;
  List<String> listPlants;

  User({required this.username, required this.mail, required this.listPlants});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      mail: json['mail'],
      listPlants: List<String>.from(json['listPlants']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'mail': mail,
      'listPlants': listPlants,
    };
  }
}
