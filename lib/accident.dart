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

Future<void> GetAddressFromLatLong(Position position, String location)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    //String? street = place.street;
    // remove space from street name
    address = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}';
    String loc = location;
    List<String> num = ["8089374989"];
    for(int i=0;i<num.length; i++){
      msgnumber(num[i], loc, address);
    }
    //msgnumber(num, loc, address);
    setState(()  {
    });
  }

  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 10);

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        timerfinished();
        showSMSsent();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void timerfinished() async{
      Position position = await _getGeoLocationPosition();
      location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      GetAddressFromLatLong(position, location);
  }

  void showSMSsent() {
    const snackBar2 = SnackBar(
      content: Text('SMS Sent'),
      );
    ScaffoldMessenger.of(context).showSnackBar(snackBar2);
  }

  void msgnumber(String number, String location, String address){
     telephony.sendSms(
	    to: number,
	    message: "Emergency! Accident detected!\n$location\nCoordinate: $address",
    );

  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final seconds = strDigits(myDuration.inSeconds.remainder(60));
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
            
            startTimer();

            // snackpack code
            const snackBar1 = SnackBar(
              content: Text('Collecting Location.'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar1);
              
              //Position position = await _getGeoLocationPosition();
              //location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
              //GetAddressFromLatLong(position, location);
	          
          }, 
          child: const Text('Trigger Accident'),
        ),

        const Text(
          "Timer",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20
          ),
          ),

        Text(
              seconds,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),


        ElevatedButton(
              onPressed: () {
                if (countdownTimer == null || countdownTimer!.isActive) {
                  stopTimer();
                }

                const snackBar3 = SnackBar(
                  content: Text('Timer Stopped. SMS not sent.'),
                  );
                ScaffoldMessenger.of(context).showSnackBar(snackBar3);
              },
              child: const Text(
                'Stop',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),

        ]
      ),
      ),
    );
  }

}



