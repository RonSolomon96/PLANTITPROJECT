import 'package:flutter/material.dart';
import '../reusableWidgets/reusableWidget.dart';
import 'homeScreen.dart';

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
              colors: [Color(0xffbcd6c3), Color(0xffa1cfac), Color(0xff72d48a), Color(0xff65d584)]
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
                loginSignupButton(context, false, () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));}),
                loginSignupOption(context, true, "Already have account ? ", "Log In"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
