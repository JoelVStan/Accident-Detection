import 'package:accident_detection/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {



  final _namecontroller = TextEditingController();
  final _numbercontroller = TextEditingController();

  addNumbertoFirebase() async {
    // FirebaseAuth Auth = FirebaseAuth.instance;
    // final User? user = Auth.currentUser;
    final user = FirebaseAuth.instance.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();

    await FirebaseFirestore.instance.collection('users').doc(uid).collection('my contacts').doc(time.toString()).set({
      'name': _namecontroller.text,
      'number' : _numbercontroller.text,
    });
    Fluttertoast.showToast(msg: 'Contact added');
  }

  void createNewContact() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: _namecontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter name",
                  ),
                ),
                SizedBox(height: 10,),

                TextField(
                  controller: _numbercontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter number",
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        addNumbertoFirebase();
                        Navigator.of(context).pop();                      
                        },

                      color: Colors.purpleAccent,
                      child: Text('Save',
                      style: TextStyle(color: Colors.white),),
                      ),
                      const SizedBox(width: 55,),

                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _namecontroller.clear();
                          _numbercontroller.clear();
                        },
                        color: Colors.purpleAccent,
                        child: Text('Cancel',
                        style: TextStyle(color: Colors.white),),
                        ),
                  ],
                )
              ],
            ),
          ),
        );
      });
  }

  String uid = '';

  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid() {
    final user = FirebaseAuth.instance.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f8ff),
      appBar: AppBar(
        title: Text('Emergency Contacts',
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold
          )
        ),),
        backgroundColor: Color(0xFF1D3557),
        centerTitle: true,
        elevation: 1,
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: createNewContact,
        backgroundColor: Color(0xFF1D3557),
        child: Icon(Icons.add_ic_call_rounded),
        ),

        body: Container(
          height: MediaQuery.of(context).size.height,
          width:  MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(uid).collection('my contacts').snapshots(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              else{
                final docs = snapshot.data?.docs;
                return ListView.builder(
                  itemCount: docs?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),                        
                      child: Container(                        
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFFE63946),
                          //border: Border.all(color: Colors.purpleAccent.shade400, width: 2),
                          borderRadius: BorderRadius.circular(12)
                    
                        ),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text(docs![index]['name'] + ': ' + docs[index]['number'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15, 
                                fontWeight: FontWeight.w600),
                                )),
                            ],),
                          ],
                        ),
                      ),
                    );
                    
                  } ,
                  );
              }
            },
            ),
        ),
    );
  }
}