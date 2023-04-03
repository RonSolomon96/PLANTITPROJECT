import 'package:flutter/material.dart';
import 'package:plantit/screens/values/colors_palette.dart';
import 'package:plantit/screens/values/constants.dart';

class TitleAndPrice extends StatelessWidget {
  const TitleAndPrice({
    Key? key,
    required this.title,
    required this.country,
    required this.price,
  }) : super(key: key);

  final String title, country;
  final int price;

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
                  text: "$title\n",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: ColorsPalette.kTextColor,
                      fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: "country",
                  style: TextStyle(
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