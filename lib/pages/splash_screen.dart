import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG support
import 'package:untitled1/pages/home.dart';
import 'package:untitled1/pages/userdetailgetter.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:untitled1/utils/sharedpreferencesutil.dart';


/*
after this page there should be 3 landing pages if the user is not logged int
or lese it should direct to the homesreen
 */

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // Hide status bar

    // Navigate after 4 seconds
    Future.delayed(Duration(seconds: 4), () {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    bool isLoggedIn = await SharedPreferencesUtil.getBooleanValue(Constants.USER_LOGGED_IN);
    // Navigate to the appropriate screen based on login status
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.APPCOLOUR,
      body: Center(
        child: SvgPicture.asset(
          'assets/svgIcons/applogo.svg', // Replace with your SVG file path
          height: 100, // Adjust height as needed
          width: 100, // Adjust width as needed
        ),
      ),
    );
  }
}