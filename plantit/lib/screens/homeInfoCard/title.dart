import 'package:flutter/material.dart';
import 'package:plantit/screens/values/colors_palette.dart';
import 'package:plantit/screens/values/constants.dart';

class TitleName extends StatelessWidget {
  const TitleName({
    Key? key,
    required this.name,
    required this.cName,
  }) : super(key: key);

  final String name;
  final String cName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$name\n",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: ColorsPalette.kTextColor,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: cName,
                  style: const TextStyle(
                    fontSize: 20,
                    color: ColorsPalette.kPrimaryColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}