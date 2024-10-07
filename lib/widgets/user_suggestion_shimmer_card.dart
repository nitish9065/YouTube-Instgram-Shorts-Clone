import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../common.dart';
import '../constants.dart';

Widget userSuggestionShimmerCard(){
  return Container(
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.grey[200],
    ),
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
            height: 60,
            width: Get.width,
            child: Card(
              margin: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              color: Colors.purple[300],
            )),
        Positioned(
            right: 0,
            left: 0,
            top: 15,
            child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                child: Shimmer(
                  gradient: shimmerGradient,
                  child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),)))),
       
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer(
                  gradient: shimmerGradient,
                  child: Container(
                    height: 20,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black),
                  )),
              giveSpace(height: 4),
              Shimmer(
                  gradient: shimmerGradient,
                  child: Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black),
                  )),
              giveSpace(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Shimmer(
                    gradient: shimmerGradient,
                    child: Container(
                      height: 30,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black),
                    )),
              )
            ],
          ),
        )
      ],
    ),
  );

}