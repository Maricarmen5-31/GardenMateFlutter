import 'package:flutter/material.dart';
import 'package:garden_mate/utils/constants.dart';

class DatoIoTWidget extends StatelessWidget {
  final double height;
  final String image;
  final String text;
  const DatoIoTWidget({super.key, required this.height, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(
          height: height,
          child:
          Image.asset(image),
        ),
        Text(text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: Constants.primaryColor,
          ),
        ),
      ],
    );
  }
}