import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shorts_clone/widgets/shimmer_grid.dart';

import '../common.dart';
import '../constants.dart';

class ProfileScreenShimmer extends StatelessWidget {
  const ProfileScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: const Text("User Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            giveSpace(height: 16),
            //main profile pic and followers, following, and post count...
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer(
                      gradient: shimmerGradient,
                      child: Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      )),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Shimmer(
                              gradient: shimmerGradient,
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            giveSpace(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer(
                      gradient: shimmerGradient,
                      child: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black),
                      )),
                  giveSpace(height: 4),
                  Shimmer(
                      gradient: shimmerGradient,
                      child: Container(
                        height: 20,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black),
                      )),
                ],
              ),
            ),
            giveSpace(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Shimmer(
                          gradient: shimmerGradient,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black),
                          ))),
                  giveSpace(width: 8),
                  Expanded(
                      child: Shimmer(
                          gradient: shimmerGradient,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black),
                          ))),
                  giveSpace(width: 8),
                  Shimmer(
                      gradient: shimmerGradient,
                      child: Container(
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black),
                      )),
                ],
              ),
            ),
            giveSpace(height: 16),
            shimmerVideoGrid(length: 10)
          ],
        ),
      ),
    );
    
  }
}