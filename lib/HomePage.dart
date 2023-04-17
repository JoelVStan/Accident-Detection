import 'package:accident_detection/accident.dart';
import 'package:accident_detection/addcontact_page.dart';
import 'package:accident_detection/auth/login.dart';
import 'package:accident_detection/bluetooth.dart';
import 'package:accident_detection/emergency_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'info.dart';


final currentUser = FirebaseAuth.instance.currentUser;

// Name, email address, and profile photo URL
String? _name = 'UserFullname';
String? _email = 'email';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    EmergencyPage(),
    InfoPage(),
  ];

    // list of smart devices
  // List myIcons = [
  //   // [ pageName, iconPath]
  //   ["Accident Detection", const Icon(Icons.bike_scooter_rounded)],
  //   ["Emergency Contacts", const Icon(Icons.contacts_rounded)],
  //   ["Settings", const Icon(Icons.settings)],
  //   ["About App", const Icon(Icons.info_outline_rounded)],
  // ];

  late SharedPreferences sharedPreferences;

  @override
  void initState(){
    setUsernameAndEmail();
    super.initState();
  }

  void setUsernameAndEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
        _email = sharedPreferences.getString('email'); // email of the currently logged in user
        _name = sharedPreferences.getString('full_name'); // full name of the currently logged in user
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f8ff),
      appBar: AppBar(
        backgroundColor: Color(0xFF1D3557),
        actions: [
          IconButton(
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.clear();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const LoginForm()), (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
        title: Text('Home',
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold
          )
        ),),
      ),
      drawer: const NavigationDrawer(),
      body: 
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // welcome user
            SizedBox(height: 35,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome,',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF457B9D),
                      fontWeight: FontWeight.w500,
                    )
                  ),),
                  Text(_name!,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Color(0xFF457B9D),
                      fontWeight: FontWeight.bold,
                      fontSize: 35
                    )
                  ),),
                ],
              ),
            ),
        
            SizedBox(height: 30,),
        
            Center(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/icon-2.png',
                  height: 250,
                  ),
        
                Text('Accident Detection\nApplication',
                textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Color(0xFFE63946),
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    )
                  ),),
                ],
                
              ),
            ),
        
            SizedBox(height: 20,),
        
            // Expanded(
            //   child: GridView.builder(
            //     itemCount: 4,
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2), 
            //     itemBuilder: (context, index) {
            //       return GridBox(
            //         pageName: myIcons[index][0],
            //         iconPath: myIcons[index][1],
            //       );
                  
            //     }
            //   )
              
            //   ),
        
          ] 
        ),
      ), 
      

      
      
      // bottomNavigationBar: CurvedNavigationBar(
      //   index: 0,
      //   backgroundColor: Colors.white,
      //   color: Colors.purpleAccent.shade200,
      //   animationDuration: Duration(milliseconds: 300),
      //   items: [
      //   Icon(Icons.home, color: Colors.white,),
      //   Icon(Icons.contacts_outlined, color: Colors.white,),
      //   Icon(Icons.settings, color: Colors.white,)
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       //_page = index;
      //     });
      //   },),
      );
      
  }

}






class NavigationDrawer extends StatelessWidget {
    const NavigationDrawer({super.key});
    
  
    @override
    Widget build(BuildContext context) => Drawer(
      backgroundColor: Color(0xFFf3f8ff),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );

  

    Widget buildHeader(BuildContext context) => Container(
      color: Color(0xFF1D3557),
      padding: EdgeInsets.only(
        top: 24 + MediaQuery.of(context).padding.top,
        bottom: 24
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg'),
          ),
          SizedBox(height: 12,),
          Text(
            '$_name',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 28, color: Color(0xFFf3f8ff))),
            ),
            Text(
              '$_email',
              style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 14, color: Colors.white)),
            ),
      ],)
        
    );

    Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Color(0xFF1D3557),),
            title: Text('Home',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600
              )
            ),),
            onTap: () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const HomePage(),
              )),
          ),
          ListTile(
            leading: const Icon(Icons.bluetooth, color: Color(0xFF1D3557),),
            title:  Text('Bluetooth Connection',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600
            )
            )
            ),
            // onTap: () => 
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => BluetoothPage(title: 'Bluetooth',),
            //   )),
          ),
          ListTile(
            leading: const Icon(Icons.two_wheeler_outlined, color: Color(0xFF1D3557),),
            title: Text('Accident Detection',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600
              ))),
            onTap: () => {
            Navigator.pop(context), // to close navigation drawer coming back
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AccidentButtonPage(),
              )),
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts_outlined, color: Color(0xFF1D3557),),
            title: Text('Emergency Contacts',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600
              ))),
            onTap: () => {
              Navigator.pop(context),
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EmergencyPage(),
                
              )),
            },
          ),
          const Divider(color: Color(0xFF1D3557)),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Color(0xFF1D3557),),
            title: Text('Settings',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600
              ))),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFF1D3557),),
            title: Text('About App',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600
              ))),
            onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const InfoPage(),
              )),
          ),
        ],
      )
    );
      
}


