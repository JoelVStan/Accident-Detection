import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Accident Detection'),
        ),
        body: const Center(
          child: Text(
            'Welcome to Accident Detection App',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              color: Colors.teal,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(
                  Icons.home,
                  //color: Colors.blue,
                  size: 24,
                )),
            BottomNavigationBarItem(
                label: 'Detect Accident',
                icon: Icon(
                  Icons.two_wheeler,
                  size: 24,
                ))
          ],
          currentIndex: currentIndex,
          onTap: (int index){ 
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class TriggerButtonPage extends StatelessWidget {
  const TriggerButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}