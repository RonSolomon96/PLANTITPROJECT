import 'package:flutter/material.dart';
import 'package:plantit/reusable/reusableFuncs.dart';
import '../reusable/reusableWidget.dart';
import 'dart:convert';
import 'rootScreen.dart';
import 'package:http/http.dart' as http;

String url = "http://192.168.1.166:5000";

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {


  TextEditingController emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffbcd6c3), Color(0xffa1cfac), Color(0xff72d48a), Color(0xff65d584)]
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                reusableTextField("Enter Email", Icons.email_outlined, false, emailTextController),
                const SizedBox(height: 20),
                senToServerButton(context, "Reset Password", (){reset(context);})
              ],
            ),
          ),
        ),
      ),
    );
  }

  //the reset function
  void reset(BuildContext context) async {
    await http.post(
        Uri.parse("$url/resetPass" ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email" : emailTextController.text
        })).then((value) => {
      if(value.statusCode == 201) {
        emailTextController.clear(),
        // If the server did return a 201 CREATED response,
        //then move to home screen
        Navigator.of(context).pop()
      } else {
        // If the server did not return a 201 CREATED response,
        // then show snackbar.
        showSnackbar(context, "No account with the specified email.")
      }
    });
  }
}


