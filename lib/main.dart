import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/blank.dart';
import 'package:untitled1/pages/home.dart';
import 'package:untitled1/pages/landingPage.dart';
import 'package:untitled1/pages/userdetailgetter.dart';
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
    await Future.delayed(Duration(milliseconds: 500)); // Adjust delay as needed
    set();

  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(SafeArea(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home : Landingpage()
      )
  ));
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
          headlineMedium: TextStyle(color: Colors.white),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Constants.WHITE,
          labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Constants.WHITE),
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
      home: FutureBuilder(
        future: SharedPreferencesUtil.getBooleanValue(Constants.USER_LOGGED_IN),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data! ? Home() : UserDetailGetter();
          } else {
            return Blank();
          }
        },
      ),
    );
  }
}
