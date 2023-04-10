import 'package:flutter/material.dart';
import 'package:accident_detection/functions/authFunctions.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f8ff),
      appBar: AppBar(
        backgroundColor: Color(0xFF1d3557),
        elevation: 0,
        title: Text('Authentication',
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        ),),
      ),
      body: SingleChildScrollView(
        
        child: Form(
          key: _formKey,
          child: Container(
          
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // welcome text
                Text('Welcome!',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFF457B9D)
                  )
                ),
                ),
      
                SizedBox(height: 20,),
      
      
                // ======== Full Name ========
                login
                    ? Container()
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFFf3f8ff),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                            key: ValueKey('fullname'),
                            decoration: InputDecoration(
                              hintText: 'Full Name',
                              hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(color: Colors.grey),
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Full Name';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                fullname = value!;
                              });
                            },
                          ),
                      ),
                    ),
      
                // ======== Email ========
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFf3f8ff),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    child: TextFormField(
                      key: ValueKey('email'),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: GoogleFonts.montserrat(
                          textStyle: TextStyle(color: Colors.grey),
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please Enter valid Email';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          email = value!;
                        });
                      },
                    ),
                  ),
                ),
                // ======== Password ========
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFf3f8ff),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.montserrat(
                          textStyle: TextStyle(color: Colors.grey),
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Please Enter Password of min length 6';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          password = value!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                // button
      
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          login
                              ? AuthServices.signinUser(email, password, context)
                              : AuthServices.signupUser(
                                  email, password, fullname, context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFFE63946),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            login ? 'Login' : 'Sign Up', style: GoogleFonts.montserrat(
                              textStyle: TextStyle(color: Colors.white),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ))))),
                ),
                SizedBox(
                  height: 2,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        login = !login;
                      });
                    },
                    child: Text(login
                        ? "Don't have an account? Signup"
                        : "Already have an account? Login", 
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(color: Color(0xFF457B9D),
                          fontWeight: FontWeight.w600),
                          fontSize: 14)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}