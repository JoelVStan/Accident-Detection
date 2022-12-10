import 'package:flutter/material.dart';


class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accident Detection'),
      ),
      body: const Center(
        child: Text(
            'Information Page',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.purple, 
            ),
        ),
      ),
      
    );
  }
}