import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

Widget shimmerUserGrid({required int length}) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        childAspectRatio: 3 / 4
        // mainAxisExtent: Get.height/3.25
        ),
    itemBuilder: (context, index) {
      return const Shimmer(
        gradient: shimmerGradient,
        direction: ShimmerDirection.ttb,
        child: Card(
          color: Colors.black87,
        ),
      );
    });
Widget shimmerVideoGrid({required int length}) => GridView.builder(
    shrinkWrap: true,
    padding: const EdgeInsets.only(bottom: 16),
    physics: const NeverScrollableScrollPhysics(),
    itemCount: length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 2, crossAxisSpacing: 2, crossAxisCount: 3),
    itemBuilder: (context, index) {
      return SizedBox(
        height: 150,
        width: 150,
        child: Shimmer(
            gradient: shimmerGradient,
            child: Container(
              color: Colors.deepPurple,
            )),
      );
    });
