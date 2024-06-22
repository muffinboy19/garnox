import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/components/announcement_card.dart';
import 'package:untitled1/utils/sharedpreferencesutil.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/utils/contstants.dart'; // Adjust import path if necessary
import 'dart:convert';
import 'package:untitled1/components/navDrawer.dart';

class Announcement extends StatefulWidget {
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  bool admin = false;
  User userLoad = User(); // Initialize with an empty User object
  List<Widget> updatesList = []; // Use List<Widget> for list of announcements

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    await Firebase.initializeApp(); // Initialize Firebase app
    await fetchUserDetailsFromSharedPref();
    await checkIfAdmin();
    await fetchUpdates();
  }

  Future<void> fetchUserDetailsFromSharedPref() async {
    try {
      var result = await SharedPreferencesUtil.getStringValue(
          Constants.USER_DETAIL_OBJECT);
      if (result != null) {
        Map<String, dynamic> valueMap = json.decode(result); // Explicit type casting
        User user = User.fromJson(valueMap);
        setState(() {
          userLoad = user;
        });
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }

  Future<void> checkIfAdmin() async {
    try {
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
    } catch (error) {
      print('Error checking admin status: $error');
    }
  }

  Future<void> fetchUpdates() async {
    try {
      await for (var snapshot in FirebaseFirestore.instance
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .snapshots()) {
        List<Widget> newUpdatesList = [];
        for (var message in snapshot.docs) {
          String title =
              message.data()['title'] ?? 'Event Title Unavailable';
          String messageText =
              message.data()['message'] ?? 'Message Text Unavailable';
          String url = message.data()['url'] ?? null;
          final timestamp =
              message.data()['createdAt'] ?? DateTime.now().millisecondsSinceEpoch;
          var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
          String displayDate =
          DateFormat("dd MMM yyyy hh:mm a").format(date);

          newUpdatesList.add(AnnounceCard(
            title: title,
            date: displayDate,
            message: messageText,
            url: url,
          ));
        }
        setState(() {
          updatesList = newUpdatesList;
        });
      }
    } catch (error) {
      print('Error fetching announcements: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        userData: userLoad,
        admin: admin,
      ),
      appBar: AppBar(
        title: Text('Announcements'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: updatesList.isEmpty
            ? Center(
          child: Text('No Announcements Yet!'),
        )
            : ListView.builder(
          itemCount: updatesList.length,
          itemBuilder: (BuildContext context, int index) {
            return updatesList[index];
          },
        ),
      ),
    );
  }
}
