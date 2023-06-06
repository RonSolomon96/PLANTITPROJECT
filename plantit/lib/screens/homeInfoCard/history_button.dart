import 'package:flutter/material.dart';
import 'package:plantit/screens/values/colors_palette.dart';
import '../care_plan_history.dart';

class HistoryButton extends StatelessWidget {
  var cPlnat;
  final String userEmail;

   HistoryButton({Key? key,
     required this.userEmail,
     required this.size,
     required this.cPlnat,
  }) : super(key: key);

  final Size size;
   String? _nickname;
   final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * 0.6,
            height: 40,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(userEmail: userEmail, plant: cPlnat["nickname"]),
                    ),
                  );
                },
              style: ElevatedButton.styleFrom(
                primary: ColorsPalette.kPrimaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: const Text(
                "History",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}