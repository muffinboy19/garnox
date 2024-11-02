import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/components/NetworkError.dart';
import 'package:untitled1/pages/CollegeDetails.dart';
import 'package:untitled1/pages/HomePage.dart';
import 'package:untitled1/pages/ProfilePage.dart';
import 'package:untitled1/pages/landingPage.dart';
import 'package:untitled1/pages/sem_vise_subjects.dart';
import 'package:untitled1/pages/signin.dart';
import 'package:untitled1/pages/splash_screen.dart';
import 'package:untitled1/utils/Functions.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:untitled1/utils/sharedpreferencesutil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBLysTDQ5ZZYfGy5EB1hzr6UpMNss2U33Q",
        appId: '1:713083156511:android:61ad2890f9d3d219fb3d2a',
        messagingSenderId: "713083156511",
        projectId: "sembreaker-49515",
      ),
    );
    print('[FIREBASE] Firebase initialized successfully');

    // Introduce a delay before calling set()
    // await Future.delayed(Duration(milliseconds: 500)); // Adjust delay as needed
    //set(); // Assuming 'set()' is defined elsewhere
  } catch (e) {
    print('Error initializing Firebase:$e');
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging firebaseMessaging;

  @override
  void initState() {
    super.initState();
    // Set the status bar color to blue
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

    firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.subscribeToTopic('notifications');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashColor: Constants.SKYBLUE,
        fontFamily: 'Montserrat',
        primaryColor: Constants.DARK_SKYBLUE,
        primaryIconTheme: IconThemeData(color: Colors.white),
        indicatorColor: Constants.WHITE,
        primaryTextTheme: TextTheme(
          headlineMedium: TextStyle(color: Colors.white),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Constants.WHITE,
          labelStyle:
              TextStyle(fontWeight: FontWeight.w600, color: Constants.WHITE),
          unselectedLabelColor: Constants.SKYBLUE,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Constants.SKYBLUE,
        ),
      ),
      title: 'SemBreaker',
      debugShowCheckedModeBanner: false,
      // Define your routes here (remove the '/' entry since you have 'home')
      routes: {
        '/home': (context) => HomePage(), // Route for your home screen
        //'/signin': (context) => SignIn(),
        //'/about': (context) => AboutUs(),
        //'///admin': (context) => Admin(),
        //'/announcements': (context) => Announcements(),
        // '/pdf': (context) => PDFScreen(),
        // '/semisterAskingPage': (context) => SemsiterAskingPage(),
        //'/subject': (context) => Subject(), // You might need to adjust this based onhow you pass data to Subject
      },
      home: FutureBuilder(
        future: SharedPreferencesUtil.getBooleanValue(Constants.USER_LOGGED_IN),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data! ? SplashScreen() : SplashScreen()
            ;
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
