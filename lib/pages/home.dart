import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/custom_loader.dart';
import 'package:untitled1/components/error_animatedtext.dart';
import 'package:untitled1/components/navDrawer.dart';
import 'package:untitled1/components/nocontent_animatedtext.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/subject.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  User userLoad = User();
  late ScrollController _scrollController;
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

  @override
  void initState() {
    super.initState();
    fetchUserDetailsFromSharedPref();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          break;
        case ScrollDirection.reverse:
          break;
        case ScrollDirection.idle:
          break;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavDrawer(userData: userLoad, admin: admin),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Home',
          style: GoogleFonts.epilogue(
            textStyle: TextStyle(
              color: Constants.BLACK,
              fontWeight: FontWeight.bold,),
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgIcons/hamburger.svg",
            color:Constants.BLACK,
          ),
          onPressed: () {
            // Handle drawer opening
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/svgIcons/notification.svg",
              color:Constants.BLACK,
            ),
            onPressed: () {
              // Handle notification action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding( // Added search bar
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search subjects...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (text) {
                  // Implement search logic here
                },
              ),
            ),
            SizedBox(height: 16), // Space between search bar and heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Subjects",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded( // To allow horizontal scrolling
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Semesters')
                    .doc('${currentSemester}')
                    .snapshots(),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.hasData && snapshot.data!.exists) {Map<String, dynamic> branchSubjects =
                    (snapshot.data!.data() as Map<String, dynamic>)['branches']
                    ['${currentBranch?.toUpperCase()}']
                    as Map<String, dynamic>;
                    return ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal, // Horizontal scrolling
                      itemCount: branchSubjects.length,
                      separatorBuilder: (context, index) => SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        String key = branchSubjects.keys.elementAt(index);
                        String value = branchSubjects[key];
                        return SubjectCard(subjectCode: key, subjectName: value);
                      },

                    );
                    }
                  } catch (err) {
                    return ErrorAnimatedText(key: null);
                  }
                  return CustomLoader();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class SubjectCard extends StatelessWidget {
  final String subjectCode;
  final String subjectName;

  const SubjectCard({required this.subjectCode, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("[asd]   SubjectCode Tapped: $subjectCode");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Subject(
              subjectCode: subjectCode,
            ),
          ),
        );
      },
      child: Column(
        children: [Container(
          width: 150,
          height: 100, // Reduced height of the box
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Color(0xFFE8E5EF),
            child: Center(
              child: SvgPicture.asset(
                "assets/svgIcons/file.svg", // Replace with your actual SVG path
                width: 30, // Adjust size as needed
                height: 30,
                color: Constants.APPCOLOUR,
              ),
            ),),
        ),
          SizedBox(height: 8),
          Text(
            subjectCode,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),), // Display subject name
        ],
      ),
    );
  }
}