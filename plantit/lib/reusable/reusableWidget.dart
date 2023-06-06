import 'package:flutter/material.dart';
import '../screens/signupScreen.dart';

///the application logo
Image logoWidget(String imagePath, double width, double height) {
  return Image.asset(
    imagePath,
    fit: BoxFit.fitHeight,
    width: width,
    height: height,
    color: Colors.white,
  );
}

Text titleWidget(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 40,
      fontWeight: FontWeight.bold,
      //fontFamily: 'IndieFlower'
    ),
  );
}


TextField reusableTextField(String text, IconData icon, bool isPassword, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70,),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      )
    ),
    keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

///for login, register or reset password
Container senToServerButton(BuildContext context, String title, Function onPress) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onPress();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          else {
            return Colors.white;
          }
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
        )
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}

/// back to login or move to register
Row loginSignupOption(BuildContext context,bool forLogin, String first, String second, Function cleanFields) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(first , style: const TextStyle(color: Colors.white70, fontSize: 15),),
      GestureDetector(
        onTap: () {
          cleanFields();
          forLogin?
          Navigator.pop(context)
          : Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignupScreen()));
        },
        child: Text(
          second,
          style: const TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}