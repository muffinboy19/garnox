import 'package:flutter/material.dart';
import 'package:untitled1/pages/home.dart';
import 'package:untitled1/utils/signinutil.dart';

class SignIn extends StatelessWidget {
  final String? college;
  final int? batch;
  final String? branch;
  final int? semester;

  SignIn({
     this.college,
     this.batch,
     this.branch,
     this.semester,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Image(
                  image: AssetImage("assets/images/Logo.png"),
                  height: 300.0,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(color: Colors.grey),
                  ),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.grey.withOpacity(0.1);
                        }
                        return Colors.transparent;
                      }),
                ),
                onPressed: () {
                  signInWithGoogle(context);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/images/google_logo.png"),
                        height: 35.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signInWithGoogle(BuildContext context) {
    SignInUtil(
      college: college!,
      semester: semester!,
      batch: batch!,
      branch: branch!,
    ).signInWithGoogle().then((_) {
      // Navigate to home screen after sign-in is complete
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }).catchError((error) {
      // Handle sign-in errors here
      print("Error signing in: $error");
      // Optionally show an error message to the user
    });
  }
}
