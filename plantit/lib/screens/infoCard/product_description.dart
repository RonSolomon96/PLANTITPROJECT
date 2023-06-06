import 'package:flutter/material.dart';
import 'package:plantit/screens/values/colors_palette.dart';

class ProductDescription extends StatelessWidget {
  final Size size;
  final String des;

  const ProductDescription({
    Key? key,
    required this.size,
    required this.des,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 8),
      child: Container(
        width: double.infinity,
        height: size.height * 0.3,
        color: const Color.fromARGB(24, 31, 252, 178),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Description:",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: ColorsPalette.kTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: des,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: const Color.fromARGB(255, 56, 75, 49),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
