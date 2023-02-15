import 'package:flutter/material.dart';
import 'package:accident_detection/HomePage.dart';
import 'package:accident_detection/accident.dart';
import 'package:accident_detection/info.dart';
import 'package:accident_detection/bluetooth.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MyBottomBar(),

    );
  }
}




class MyBottomBar extends StatefulWidget {
  const MyBottomBar({super.key});
  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    AccidentButtonPage(),
    InfoPage(),
    BluetoothPage(title: 'Bluetooth Connection',),
  ];

  void onTappedBar(int index)
  {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            backgroundColor: Colors.blue,
            icon: Icon(
              Icons.home,
              size: 24,
              //color: Colors.blue,
              ),
            ),
            BottomNavigationBarItem(
            label: 'Detect Accident',
            icon: Icon(
              Icons.two_wheeler,
              size: 24,
              ),
            ),
            BottomNavigationBarItem(
            label: 'Info',
            icon: Icon(
              Icons.info,
              size: 24,
              ),
            ),
            BottomNavigationBarItem(
            label: 'Bluetooth',
            icon: Icon(
              Icons.bluetooth,
              size: 24,
              ),
            ),
        ],
      ),
    );
  }
}