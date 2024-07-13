import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/pages/CollegeDetails.dart';
import 'package:untitled1/pages/HomePage.dart';

import '../components/custom_helpr.dart';
import '../database/Apis.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();

    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUser Additional Info: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        } else {
          APIs.createGoogleUser().then((value) => {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const CollegeDetails()))
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, "Something Went Wrong(Check Internet!!)");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              top: mq.height * .15,
              right: _isAnimate ? mq.width * .15 : -mq.width * .5,
              child: Container(
                width: mq.width * .7,
                child: Image.asset('assets/svgIcons/page2.png'),
              ),
            ),

            //google login button
            Positioned(
                bottom: mq.height * .15,
                left: mq.width * .05,
                width: mq.width * .9,
                height: mq.height * .06,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromARGB(255, 223, 255, 187),
                        shape: const StadiumBorder(),
                        elevation: 1),

                    // on tap
                    onPressed: () {
                      _handleGoogleBtnClick();
                    },

                    //google icon
                    icon: Image.asset('assets/images/google_logo.png',
                        height: mq.height * .03),

                    //login with google label
                    label: RichText(
                      text: const TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                            TextSpan(text: 'Login with '),
                            TextSpan(
                                text: 'Google',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ]),
                    ))),
          ],
        ));
  }
}