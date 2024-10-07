import 'package:flutter/material.dart';

Widget transparentButton(
        {String? buttonText, required VoidCallback onTap, bool? isIcon = false, IconData? iconData}) =>
    ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.purple.shade500)),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16)),
        onPressed: onTap,
        child: isIcon! ?Icon(iconData!, color: Colors.purple.shade500,size: 20,) :Text(
          buttonText!,
          style: TextStyle(color: Colors.purple.shade500),
        ));
