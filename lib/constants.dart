import 'package:flutter/material.dart';
import 'package:shorts_clone/controllers/auth_controller.dart';
import 'package:shorts_clone/screens/add_video.dart';
import 'package:shorts_clone/screens/message_screen.dart';
import 'package:shorts_clone/screens/profile_screen.dart';
import 'package:shorts_clone/screens/search_screen.dart';
import 'package:shorts_clone/screens/video_screen.dart';

const bgColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;
var pages = [
  VideoHomePage(),
  const SearchScreen(),
  const AddVideo(),
  const MessageScreen(),
  ProfileScreen(uid: AuthController.instance.user.uid,),
];
const shimmerGradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 206, 206, 219),
    Color.fromARGB(255, 212, 209, 209),
    Color.fromARGB(255, 222, 222, 235),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
const videoPlayerGradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 97, 95, 95),
    Color.fromARGB(255, 166, 166, 175),
    Color.fromARGB(255, 55, 55, 56),
  ],
  
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
const musicGradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 153, 86, 97),
    Color.fromARGB(255, 221, 11, 11),
    Color.fromARGB(255, 177, 55, 25),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
