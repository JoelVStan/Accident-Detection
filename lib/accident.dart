import 'package:flutter/material.dart';


class AccidentButtonPage extends StatefulWidget {
  const AccidentButtonPage({super.key});

  @override
  State<AccidentButtonPage> createState() => _AccidentButtonPageState();
}

class _AccidentButtonPageState extends State<AccidentButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accident Detection'),
      ),
      body: const Center(
        child: Text(
            'Accident Trigger Button',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.red, 
            ),
        ),
      ),
      
    );
  }
}