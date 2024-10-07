import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/constants.dart';
import 'package:shorts_clone/models/user_model.dart';

import '../common.dart';
import 'transparent_button.dart';

Widget userSuggestionCard(
        {required UserModel user,
        required String buttonText,
        required VoidCallback onTap}) =>
    Container(
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
            child: Container(
              alignment: Alignment.center,
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: shimmerGradient
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(user.profilePhoto, fit: BoxFit.cover,)
              ),
            ),
          ),
          const Positioned(
              right: 3,
              top: 4,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.close,
                  size: 15,
                  color: Colors.black87,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "@${user.name}",
                  style: Get.textTheme.bodySmall!.copyWith(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                giveSpace(height: 2),
                Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.bodySmall!
                      .copyWith(color: Colors.black54, fontSize: 12),
                ),
                giveSpace(height: 4),
                transparentButton(
                    buttonText: buttonText,
                    onTap: () {
                      onTap();
                    }),
              ],
            ),
          )
        ],
      ),
    );
