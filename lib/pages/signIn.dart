import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/components/custom_helpr.dart';
import 'package:untitled1/database/Apis.dart';
import 'package:untitled1/pages/HomePage.dart';
import 'package:untitled1/pages/home.dart';
import 'package:untitled1/pages/signup.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // Light or dark depending on background color
    ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      SingleChildScrollView(

        child: Container(
          margin: EdgeInsets.only(top: 150),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child:
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Create an account to access meditations,",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "sleep sounds, music to help you focus, and",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "more",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => SignUp()));
                    },
                    child: Text(
                      "New to the app SignUp here?",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    key: ValueKey('Email'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Email address*",
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black), // label text color
                    ),
                    style: TextStyle(color: Colors.black), // input text color
                    validator: (value) {
                      if (!(value.toString().contains("@"))) {
                        return 'Invalid Email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    key: ValueKey('Password'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Password (8+ characters)*",
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black), // label text color
                      suffixIcon: Icon(Icons.emoji_events_outlined, color: Colors.black), // add your desired icon here
                    ),
                    style: TextStyle(color: Colors.black), // input text color
                    validator: (value) {
                      if (value.toString().length < 8) {
                        return 'Password is too short';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          // Show progress indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue, // Set the color to blue
                                ),
                              );
                            },
                          );

                          try {
                            // Perform the signin operation
                            await APIs.signin(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                            // Dismiss the progress indicator
                            Navigator.pop(context);

                            // Navigate to the home screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomePage()),
                            );
                          } catch (error) {
                            // Dismiss the progress indicator
                            Navigator.pop(context);

                            // Show an error message (this can be customized)
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(error.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          // Show error dialog if form is not valid
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('Please fix the errors in the form before submitting.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF407BFF)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF407BFF), width: 2.0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Handle Google sign-in

                        APIs.googleSignIn().then((user) async {
                          Navigator.pop(context);

                          if (user != null) {
                            log('\nUser: ${user.user}');
                            log('\nUser Additional Info: ${user.additionalUserInfo}');

                            if (!mounted) return;

                            if ((await APIs.userExists())) {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (_) =>  HomePage()));
                            } else {
                               Dialogs.showSnackbar(context, "Please Create New Account");
                            }
                          }
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 30),
                          Text(
                            "Continue with Google",
                            style: TextStyle(color: Color(0xFF407BFF)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Image.asset("assets/images/google_logo.png"),
                          )
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
