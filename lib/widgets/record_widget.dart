import 'package:flutter/material.dart';
import 'package:garden_mate/models/controlPlant.dart';
import 'package:garden_mate/screens/record_screen.dart';
import 'package:garden_mate/utils/constants.dart';
import 'package:page_transition/page_transition.dart';

class RecordWidget extends StatelessWidget {
  final int index;
  final List<ControlPlant> plantList;
  const RecordWidget({super.key, required this.index, required this.plantList});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: RecordScreen(
                  plantId: plantList[index].plantId,
                ),
                type: PageTransitionType.bottomToTop));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(.15),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 80.0,
        padding: const EdgeInsets.only(left: 10, top: 10),
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(.8),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 80.0,
                    child:
                    Image.asset(plantList[index].imageURL),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${plantList[index].hora} ${plantList[index].fecha}'),
                      Text(plantList[index].category),
                      Text(
                        plantList[index].plantName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Constants.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  DatoIoTWidget(
                    height: 40.0, 
                    image: 'assets/images/humedad.png', 
                    text: plantList[index].humidity.toString()
                  ),
                  DatoIoTWidget(
                    height: 40.0, 
                    image: 'assets/images/temperatura.png', 
                    text: plantList[index].temperature.toString()
                  ),
                  DatoIoTWidget(
                    height: 40.0, 
                    image: 'assets/images/sol.png', 
                    text: plantList[index].lightning.toString()
                  ),                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
