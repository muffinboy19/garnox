import 'dart:convert';

import 'package:circle_list/circle_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:untitled1/components/custom_loader.dart';
import 'package:untitled1/components/error_animatedtext.dart';
import 'package:untitled1/components/navDrawer.dart';
import 'package:untitled1/components/nocontent_animatedtext.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/subject.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:untitled1/utils/sharedpreferencesutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/CustomFlatButton.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  User userLoad = User();
  late ScrollController _scrollController;
  late AnimationController _hideFabAnimController;
  bool admin = false;
  int? currentSemester;
  String? currentBranch;

  Future fetchUserDetailsFromSharedPref() async {
    print('[SharePref]   this is the start of the function ');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentSemester = prefs.getInt('CurrentUserSemester');
      currentBranch = prefs.getString('CurrentUserBranch');
      print('[SharePref]   $currentBranch   and $currentSemester');
    });
  }

  Future checkIfAdmin() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('admins').get();
    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) {
      if (data.id == userLoad.uid) {
        setState(() {
          admin = true;
        });
      }
    });
  }

  @override
  void initState() {
    print("[SharePref]  hellow owrld ");
    super.initState();
    fetchUserDetailsFromSharedPref();
    print("[SharePref] ^^^^^^^^^^^^^^^^^^^");
    checkIfAdmin();
    _scrollController = ScrollController();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          _hideFabAnimController.forward();
          break;
        case ScrollDirection.reverse:
          _hideFabAnimController.reverse();
          break;
        case ScrollDirection.idle:
          break;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hideFabAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(userData: userLoad, admin: admin),
      appBar: AppBar(
        backgroundColor: Constants.DARK_SKYBLUE,
        elevation: 0,
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Semester ${currentSemester ?? ''}",
                style: TextStyle(
                  fontSize: 24,
                  color: Constants.WHITE,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(28),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Semesters')
              .doc('${currentSemester}')
              .snapshots(),
          builder: (context, snapshot) {
            try {
              if (snapshot.hasData && snapshot.data!.exists) {
                Map<String, dynamic> branchSubjects =
                    (snapshot.data!.data() as Map<String, dynamic>)['branches']
                            ['${currentBranch?.toUpperCase()}']
                        as Map<String, dynamic>;
                List<Widget> subjects = [];
                branchSubjects.forEach(
                  (key, value) {
                    subjects.add(
                      TextButton(
                        // Using TextButton instead of FlatButton
                        onPressed: () {
                          print("[asd]   Subject Code Tapped: $key");
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => Subject(
                                subjectCode: key,
                              ),
                            ),
                          );
                          print("[asd]   subject");


                        },
                        child: ListTile(
                          leading: Image.asset(
                            'assets/images/Computer.png',
                            height: 32,
                          ),
                          title: Text(
                            key, // Or display 'value' if you want the subject name
                            style: TextStyle(
                              color: Constants.BLACK,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            value,
                            style: TextStyle(
                              color: Constants.STEEL,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Constants.BLACK,
                            size: 36,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Constants.BLACK,
                          backgroundColor: Colors.transparent,
                          // ... other style properties ...
                        ),
                      ),
                    );
                  },
                );
                if (subjects.isEmpty) {
                  return NoContentAnimatedText();
                }
                subjects.add(
                  SizedBox(
                    height: 100,
                  ),
                );

                return Container(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: subjects.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      thickness: 0.5,
                      color: Constants.SMOKE,
                      indent: 24,
                      endIndent: 24,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return subjects[index];
                    },
                  ),
                );
              }
            } catch (err) {
              return ErrorAnimatedText(key: null,);
            }
            return CustomLoader();
          },
        ),
      ),
    );
  }
}
