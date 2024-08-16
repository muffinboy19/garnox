import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled1/pages/CollegeDetails.dart';
import 'package:untitled1/pages/HomePage.dart';
import '../components/custom_helpr.dart';
import '../database/Apis.dart';
import '../utils/contstants.dart';

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

        final email = user.user?.email;
        if (email != null && email.endsWith('@iiita.ac.in')) {
          if ((await APIs.userExists())) {
            log("User exists, navigating to HomePage");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else {
            APIs.createGoogleUser().then((value) => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const CollegeDetails()))
            });
          }
        } else {
          log("Invalid email domain");
          Dialogs.showSnackbar(context, "⚠️ Login Via Valid College Id!!");
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
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
      body: Column(
        children: [
            SizedBox(height: 50,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
              width: double.infinity,
              height: 500,
              child: Center(
                child: Column(
                  children: [
                    Lottie.asset('assets/animation/aa.json', fit: BoxFit.cover),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40,),
            Container(
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 223, 255, 187),
                    shape: const StadiumBorder(),
                    elevation: 1,
                  ),

                  // on tap
                  onPressed: () {
                    _handleGoogleBtnClick();
                  },

                  //google icon
                  icon: Image.asset('assets/images/google_logo.png',
                    height: mq.height * .03,
                  ),

              //login with google label
              label: RichText(
                  text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: 'Login with '),
                    TextSpan(
                    text: 'Google',
                    style: TextStyle(fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
               ),
              ),
            ),
        ],
      ),
    );
  }
}
