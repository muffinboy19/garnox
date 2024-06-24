import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/about.dart';
import 'package:untitled1/pages/admin.dart';
import 'package:untitled1/pages/announcements.dart';
import 'package:untitled1/pages/blank.dart';
import 'package:untitled1/pages/downloads.dart';
import 'package:untitled1/pages/home.dart';
import 'package:untitled1/pages/pdf.dart';
import 'package:untitled1/pages/signin.dart';
import 'package:untitled1/pages/splash_screen.dart';
import 'package:untitled1/pages/SemisterAskingPage.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:untitled1/utils/sharedpreferencesutil.dart';
import 'package:untitled1/pages/subject.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyALEs8MkfSicwkgA9j4ydSFXdy1_eBjRUQ",
        appId: '1:894578754844:android:73a6c032950fc8e1daa6d9',
        messagingSenderId: "894578754844",
        projectId: "sembreaker-dc528",
      ),
    );
    print('Firebase initialized successfully');

    // Introduce a delay before calling set()
    // await Future.delayed(Duration(milliseconds: 500)); // Adjust delay as needed
    set(); // Assuming 'set()' is defined elsewhere
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
          headline6: TextStyle(color: Colors.white),
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
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
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
        '/home': (context) => Home(), // Route for your home screen
        //'/signin': (context) => SignIn(),
        //'/about': (context) => AboutUs(),
        //'///admin': (context) => Admin(),
        //'/announcements': (context) => Announcements(),
        '/downloads': (context) => Downloads(),
        // '/pdf': (context) => PDFScreen(),
        '/semisterAskingPage': (context) => SemsiterAskingPage(),
        //'/subject': (context) => Subject(), // You might need to adjust this based onhow you pass data to Subject
      },
      home: FutureBuilder(
        future: SharedPreferencesUtil.getBooleanValue(Constants.USER_LOGGED_IN),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data! ? Home() : Home();
          } else {
            return Blank();
          }
        },
      ),
    );
  }
}
