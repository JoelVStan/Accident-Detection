import 'package:accident_detection/HomePage.dart';
import 'package:flutter/material.dart';
// import 'package:accident_detection/HomePage.dart';
import 'package:accident_detection/accident.dart';
import 'package:accident_detection/bluetooth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'auth/login.dart';
import 'emergency_page.dart';


void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home:MyBottomBar(),
      home: MyBottomBar(),
      // home: StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return const MyBottomBar();
      //     } else {
      //       return const LoginForm();
      //     }
      //     },
      //   ),
        
        
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
    EmergencyPage(),
    BluetoothPage(title: 'Bluetooth Connection',),
  ];

  late SharedPreferences sharedPreferences; 

  @override
  void initState(){
    checkLoginStatus(); // asynchronously check whether there is a user already logged in or not
    // super.initState();
  }

  void checkLoginStatus() async {
    print("checkLoginStatus() called");
    sharedPreferences = await SharedPreferences.getInstance();
    String? cur_token = sharedPreferences.getString("token");
    print("Current user token : $cur_token");
    if(sharedPreferences.getString("token") == null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const LoginForm()), (route) => false);
    }
  }

  void onTappedBar(int index)
  {
    setState(() {
      print("Index = $index");
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
        //fixedColor: Colors.white,
        backgroundColor: Color(0xFF1D3557),
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            backgroundColor: Color(0xFF1D3557),
            icon: Icon(
              Icons.home,
              size: 24,
              //color: Colors.blue,
              ),
            ),
            BottomNavigationBarItem(
            label: 'Detect Accident',
            //backgroundColor: Color.fromARGB(255, 255, 187, 0),
            icon: Icon(
              Icons.two_wheeler,
              size: 24,
              ),
            ),
            BottomNavigationBarItem(
            label: 'Contacts',
            icon: Icon(
              Icons.emergency_outlined,
              size: 24,
              ),
            ),
            BottomNavigationBarItem(
            //backgroundColor: Color(0xFF1D3557),
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