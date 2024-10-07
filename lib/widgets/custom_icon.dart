import 'package:flutter/material.dart';
import 'package:shorts_clone/constants.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 30,
      child: Stack(
        children: [
          Container(
            width: 38,
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 45, 108),
                border: Border.all(color: bgColor),
                borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            width: 38,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 32, 211, 234),
                border: Border.all(color: bgColor),
                borderRadius: BorderRadius.circular(10)),
          ),
          Center(child: Container(
            width: 38,
            height: double.infinity,
            decoration: BoxDecoration(
                color:  Colors.white,
                borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.add, color: Colors.black87,),),)
        ],
      ),
    );
  }
}
