import 'package:flutter/material.dart';
import 'package:shorts_clone/constants.dart';
import 'package:shorts_clone/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
@override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[200],
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          currentIndex:  pageIndex,
          selectedLabelStyle: const TextStyle(color: Colors.black87),
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black54,
          selectedItemColor: bgColor,
          unselectedLabelStyle: const TextStyle(color: Colors.black54),
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: 'Search'),
            BottomNavigationBarItem(icon: CustomIcon(), label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: 'Message'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Profile'),
          ]),
    );
  }
}
