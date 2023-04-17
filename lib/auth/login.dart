import 'package:accident_detection/Sample.dart';
import 'package:flutter/material.dart';
import 'package:accident_detection/functions/authFunctions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accident_detection/main.dart';

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
  bool _isLoading = false;

  void signIn() async {
    try {
      print("Here in signIn() -----------------------------");
      Response response = await post(
          Uri.parse(
              'https://accident-detection-alert-system-backend.onrender.com/account/login/'),
          body: {'email': email, 'password': password});
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body.toString());
        print(data);

        // login = true;
        print('Login successfull');

        // save the token
        sharedPreferences.setString("token", data['token']);
        // save the user full name

        // save the user email
        sharedPreferences.setString("email", data['email']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const MyBottomBar()),
            (route) => false);
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void signUp() async {
    try {
      print("Here in singUp() -----------------------");
      print("Fullname: $fullname");
      print("Email: $email");
      print("Password: $password");

      Response response = await post(
          Uri.parse(
              'https://accident-detection-alert-system-backend.onrender.com/account/register/'),
          body: {'full_name': fullname, 'email': email, 'password': password});

      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print("Data: $data");
        print('Account created successfully');
        signIn();
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf3f8ff),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1d3557),
        elevation: 0,
        title: Text(
          'Authentication',
          style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
      body: _isLoading ? Container(
        child: 
            const Center(
                child: CircularProgressIndicator(),
              )
      ) 
      : SingleChildScrollView(
        child: Form(
                  key: _formKey,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 150),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // welcome text
                        Text(
                          'Welcome!',
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Color(0xFF457B9D))),
                        ),
      
                        const SizedBox(
                          height: 20,
                        ),
      
                        // ======== Full Name ========
                        login
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFf3f8ff),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextFormField(
                                    controller: fullnameController,
                                    key: const ValueKey('fullname'),
                                    decoration: InputDecoration(
                                      hintText: 'Full Name',
                                      hintStyle: GoogleFonts.montserrat(
                                        textStyle:
                                            const TextStyle(color: Colors.grey),
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
                                  ),
                                ),
                              ),
      
                        // ======== Email ========
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFf3f8ff),
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: emailController,
                              key: const ValueKey('email'),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(color: Colors.grey),
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
                            ),
                          ),
                        ),
      
                        // ======== Password ========
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFf3f8ff),
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              key: const ValueKey('password'),
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(color: Colors.grey),
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
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
      
                        // button
      
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                fullname = fullnameController.text.toString();
                                email = emailController.text.toString();
                                password = passwordController.text.toString();
                                setState(() {
                                  _isLoading = true;
                                });
                                login ? signIn() : signUp();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE63946),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  login ? 'Login' : 'Sign Up',
                                  style: GoogleFonts.montserrat(
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                login = !login;
                              });
                            },
                            child: Text(
                                login
                                    ? "Don't have an account? Signup"
                                    : "Already have an account? Login",
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF457B9D),
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
