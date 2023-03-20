import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantit/screens/infoCard/buy_and_favorite_button.dart';
import 'package:plantit/screens/infoCard/image_and_icons.dart';
import 'package:plantit/screens/infoCard/product_description.dart';
import 'package:plantit/screens/infoCard/title_and_price.dart';
import 'package:plantit/screens/values/colors_palette.dart';
import 'package:plantit/screens/values/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageAndIcons(size: size),
          TitleAndPrice(
            title: "Angelica",
            country: "Germany",
            price: 856,
          ),
          BuyAndFavoriteButton(size: size),
          SizedBox(
            height: 16,
          ),
          ProductDescription(size: size),
        ],
      ),
    );
  }
}