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
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: (){}, 
          child: const Text('Trigger Accident'),
        ) 
      ),
    );
  }
}