import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:telephony/telephony.dart';

class AccidentButtonPage extends StatefulWidget {
  const AccidentButtonPage({super.key});

  @override
  State<AccidentButtonPage> createState() => _AccidentButtonPageState();
}



class _AccidentButtonPageState extends State<AccidentButtonPage> {
  String location = 'Press Button below';
  String address = "address"; 

  String message = "";
  final telephony = Telephony.instance;
  

  
  // gelocator code start
  Future<Position> _getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) { 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 
  return await Geolocator.getCurrentPosition();
}
// locator code ends

Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    address = '${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}';
    telephony.sendSms(
	    to: "9495319900",
	    message: address
            );
    setState(()  {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accident Detection'),
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text(location, style: const TextStyle(fontSize: 15)
        //),
        //Text('${address}'),
        const Text("Click Button to trigger accident", style: TextStyle(fontSize: 20)),

        
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () async{
            
            // snackpack code
            const snackBar = SnackBar(
              content: Text('Collecting Location, sending SMS'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              
              Position position = await _getGeoLocationPosition();
              //print(position.latitude);
              location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
              GetAddressFromLatLong(position);
              //String add = address;
            
            const snackBa = SnackBar(
              content: Text('SMS Sent'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBa);
            
	          
          }, 
          child: const Text('Trigger Accident'),
        ) 
        ]
      ),
      ),
    );
  }

}



