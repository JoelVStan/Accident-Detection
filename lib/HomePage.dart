import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      
    );
  }
}