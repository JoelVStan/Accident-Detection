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
      backgroundColor: Color(0xFFf3f8ff),
      appBar: AppBar(
        backgroundColor: Color(0xFF1D3557),
        title: const Text('Accident Detection'),
      ),
      body: const Center(
        
        child: 
          
          Text(
            'Accident Detection App\n\nFinal year project by:\nS Sameem\nShameemudheen M P\nJoel Varghese Stanley',
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