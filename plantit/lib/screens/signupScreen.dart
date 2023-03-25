import 'package:flutter/material.dart';
import 'package:plantit/main.dart';
import 'package:plantit/reusable/reusableFuncs.dart';
import '../reusable/reusableWidget.dart';
import 'dart:convert';
import 'rootScreen.dart';
import 'package:http/http.dart' as http;



class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {


  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController password2TextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffbfd9cc), Color(0xff8ccaaf), Color(0xff59bf96), Color.fromARGB(255, 7, 163, 111)]
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                titleWidget("Sign Up"),
                const SizedBox(height: 50),
                reusableTextField("Enter UserName", Icons.person_outline, false, userNameTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Email", Icons.email_outlined, false, emailTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outline, true, passwordTextController),
                const SizedBox(height: 20),
                reusableTextField("Confirm Password", Icons.lock_outline, true, password2TextController),
                const SizedBox(height: 20),
                senToServerButton(context, "SIGN UP", (){signUp(context);}),
                loginSignupOption(context, true, "Already have account ? ", "Log In", () {
                  emailTextController.clear();
                  userNameTextController.clear();
                  passwordTextController.clear();
                  password2TextController.clear();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //the sign up function
  void signUp(BuildContext context) async {
    //check that all fields are not empty
    if(emailTextController.text == "" || userNameTextController.text == "" ||
        passwordTextController.text == "" || password2TextController.text == "") {
      showSnackbar(context, "Please fill all fields.");
      return;
    }
    //check password and it's confirmation are the same
    if(passwordTextController.text != password2TextController.text) {
      showSnackbar(context, "The password confirmation does not match.");
      return;
    }

    //check if its a strong password
    //one that contains uppercase letters, lowercase letters, and numbers,
    // and is more than 6 characters
    String password = passwordTextController.text;
    bool isStrongPass = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$').hasMatch(password);
    if (!isStrongPass) {
      showSnackbar(context, "password must be more than 6 characters and contain"
          " at least one numeric digit, one uppercase and one lowercase letter");
      return;
    }
    //send data to server in order to create user
    await http.post(
      Uri.parse("$serverUrl/register" ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email" : emailTextController.text,
        "password" : passwordTextController.text,
        "username" : userNameTextController.text
      })).then((value) async => {
      if(value.statusCode == 201) {
        // If the server did return a 201 CREATED response,
        //then move to home screen
        await http.post(
            Uri.parse("$serverUrl/users" ),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "email" : emailTextController.text,
              "password" : passwordTextController.text,
              "username" : userNameTextController.text
            })).then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => RootScreen(userEmail: emailTextController.text)))),
        emailTextController.clear(),
        userNameTextController.clear(),
        passwordTextController.clear(),
        password2TextController.clear(),
      } else {
        // If the server did not return a 201 CREATED response,
        // then show snackbar.
        showSnackbar(context, "Email already taken or invalid.")
      }
    });
  }
}


