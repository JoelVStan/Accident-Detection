import 'package:accident_detection/HomePage.dart';
import 'package:accident_detection/api/firestore_api.dart';
import 'package:flutter/material.dart';
import 'package:accident_detection/contact_util.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  //final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    
    super.initState();
    askContactsPermission();
  }

  Future askContactsPermission() async {
    final permission = await ContactUtils.getContactPermission();
    switch (permission) {
      case PermissionStatus.granted:
        uploadContacts();
        break;
      case PermissionStatus.permanentlyDenied:
        goToHomePage();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: Text('Please allow to "Upload Contacts"'),
            duration: Duration(seconds: 3),
          ),);
        break;
    }
  }

  Future uploadContacts() async {
    final contacts =
        (await ContactsService.getContacts()).toList();

    await FirestoreApi.uploadContacts(contacts);

    goToHomePage();
  }

  void goToHomePage() => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        ModalRoute.withName('/'),
      );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts'),
        backgroundColor: Colors.deepOrange.shade400,
        centerTitle: true,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_ic_call_rounded),),
    );
  }
}