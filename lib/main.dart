import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/constants.dart';
import 'package:shorts_clone/firebase_options.dart';
import 'package:shorts_clone/screens/splash_screen.dart';
import 'package:shorts_clone/strings.dart';

import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put<AuthController>(AuthController());
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: bgColor,
        ),
        appBarTheme:  AppBarTheme(
          backgroundColor: Colors.purple[500],
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white)
        ),
          fontFamily: "BricolageGrotesque",
          textTheme: const TextTheme(
              bodyLarge: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontFamily: 'BricolageGrotesque-Bold'),
              bodyMedium: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Bricolage Grotesque-SemiBold'),
              bodySmall: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: 'Bricolage Grotesque-Regular')),
          elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.purple),
                padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.all(12)),
                textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
                    letterSpacing: 1,
                    fontSize: 14,
                    fontStyle: FontStyle.normal))),
          )),
      title: Strings.appName,
      home: const SplashScreen(),
    );
  }
}
