import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantit/screens/homeInfoCard/icon_card.dart';
import 'package:plantit/screens/values/constants.dart';

class ImageAndIcons extends StatelessWidget {
  final Size size;
  var current;

  ImageAndIcons({
    Key? key,
    required this.size,
    required this.current
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding * 1),
      child: SizedBox(
        height: size.height * 0.78,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: kDefaultPadding * 1),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        padding:
                        EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
                      ),
                    ),
                    IconCard(
                      icon: "assets/icons/sun.svg",
                    ),
                    IconCard(
                      icon: "assets/icons/icon_2.svg",
                    ),
                    IconCard(
                      icon: "assets/icons/icon_3.svg",
                    ),
                    IconCard(
                      icon: "assets/icons/icon_4.svg",
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: size.height * 0.45/*0.45*/,
              width: size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(63),
                  bottomLeft: Radius.circular(63),
                  topRight: Radius.circular(63),
                  bottomRight: Radius.circular(63),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: const Color.fromARGB(255, 3, 121, 81).withOpacity(0.29),
                  ),
                ],
                image: DecorationImage(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.cover,
                  image: NetworkImage(current["Image_url"]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}