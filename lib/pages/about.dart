import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:untitled1/components/navDrawer.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/utils/sharedpreferencesutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/contstants.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  late User userLoad;
  bool admin = false;

  @override
  void initState() {
    super.initState();
    userLoad = User(); // Initialize userLoad
    fetchUserDetailsFromSharedPref();
    checkIfAdmin();
  }

  Future<void> fetchUserDetailsFromSharedPref() async {
    var result =
    await SharedPreferencesUtil.getStringValue(Constants.USER_DETAIL_OBJECT);
    if (result != null) {
      Map<String, dynamic> valueMap = json.decode(result);
      User user = User.fromJson(valueMap);
      setState(() {
        userLoad = user;
      });
    }
  }

  Future<void> checkIfAdmin() async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        userData: userLoad,
        admin: admin,
      ),
      appBar: AppBar(title: Text('About Us')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildAccordion(
              leadingIcon: FontAwesomeIcons.featherAlt,
              title: 'About the App',
              content: Text('Hola Friends! ...'),
            ),
            _buildAccordion(
              leadingIcon: Icons.settings,
              title: 'Features',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildFeature('One place access to all the important notes...'),
                  _buildFeature('Get the material across various semesters & courses.'),
                  _buildFeature('Download the material that is important to you...'),
                  _buildFeature('If you have got the notes you want upload...'),
                ],
              ),
            ),
            _buildAccordion(
              leadingIcon: Icons.settings_ethernet,
              title: 'Contributors',
              content: Column(
                children: <Widget>[
                  _buildContributor('Avneesh Kumar', 'https://avatars1.githubusercontent.com/u/54072374', 'https://github.com/Cybertron-Avneesh'),
                  _buildContributor('Pranav Singhal', 'https://avatars2.githubusercontent.com/u/51447798', 'https://github.com/singhalpranav22'),
                  _buildContributor('Shourya', 'https://avatars3.githubusercontent.com/u/58784199', 'https://github.com/lazyp4nd4'),
                  _buildContributor('Tushar Kumar', 'https://avatars0.githubusercontent.com/u/58617063', 'https://github.com/tktakshila'),
                  _buildContributor('Yukta Gopalani', 'https://avatars2.githubusercontent.com/u/59793009', 'https://github.com/yuktagopalani'),
                ],
              ),
            ),
            _buildAccordion(
              leadingIcon: 'assets/images/geekhaven.png',
              title: 'About GeekHaven',
              content: Text(
                'GeekHaven is the technical Society of IIIT Allahabad. ...',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion({
    required dynamic leadingIcon,
    required String title,
    required Widget content,
  }) {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.all(0),
      dividerColor: Colors.transparent,
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: _buildLeadingWidget(leadingIcon),
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: content,
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildLeadingWidget(dynamic leadingIcon) {
    if (leadingIcon is IconData) {
      return Icon(
        leadingIcon,
        size: 32,
        color: Constants.DARK_SKYBLUE,
      );
    } else if (leadingIcon is String && leadingIcon.endsWith('.png')) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: AssetImage(leadingIcon),
      );
    } else {
      return Icon(
        Icons.error,
        size: 32,
        color: Constants.DARK_SKYBLUE,
      );
    }
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Montserrat'),
          children: [
            TextSpan(text: '\u2022 ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }

  Widget _buildContributor(String name, String avatarUrl, String githubUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(avatarUrl),
          radius: 24,
        ),
        title: Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        onTap: () => launch(githubUrl),
      ),
    );
  }
}
