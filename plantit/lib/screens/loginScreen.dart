import 'package:flutter/material.dart';
import 'package:plantit/screens/signupScreen.dart';
import '../reusableWidgets/reusableWidget.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

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
            colors: [Color(0xffbcd6c3), Color(0xffa1cfac), Color(0xff72d48a), Color(0xff65d584)]
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                titleWidget("Sign In"),
                const SizedBox(height: 20),
                logoWidget("assets/images/logo.png", 240, 240),
                const SizedBox(height: 30),
                reusableTextField("Enter Email", Icons.email_outlined, false, emailTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outline, true, passwordTextController),
                const SizedBox(height: 20),
                loginSignupButton(context, true, (){}),
                loginSignupOption(context, false, "New to PlantIt ? ", "Sign Up"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

