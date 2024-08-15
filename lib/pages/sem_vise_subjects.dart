import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled1/components/custom_helpr.dart';
import 'package:untitled1/database/Apis.dart';
import 'package:untitled1/pages/Subject_detail.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:untitled1/models/SemViseSubModel.dart';
import '../components/Custom_navDrawer.dart';
import '../models/SpecificSubjectModel.dart';
import 'SearchPage.dart';

class SemViseSubjects extends StatefulWidget{
  const SemViseSubjects({super.key});

  @override
  State<SemViseSubjects> createState() => _SemViseSubjectsState();
}

class _SemViseSubjectsState extends State<SemViseSubjects>{
  bool _isSearching = false;
  String _searchText = "";
  final List<SemViseSubject> _searchList = [];
  List<SemViseSubject> _list = [];
  final storage = new FlutterSecureStorage();
  late GlobalKey<RefreshIndicatorState> refreshKey;
  Random random = Random();

  @override
  void initState(){
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  Future<void> _handleRefresh() async {
    await APIs.fetchSemSubjectName();
    await APIs.fetchAllSubjects();
    await Future.delayed(Duration(seconds: 1));
  }


  @override
  Widget build(BuildContext context){
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Subjects',
            style: GoogleFonts.epilogue(
              textStyle: TextStyle(
                color: Constants.BLACK,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading: IconButton(
            icon: SvgPicture.asset(
              "assets/svgIcons/hamburger.svg",
              color: Constants.BLACK,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/svgIcons/notification.svg",
                color: Constants.BLACK,
              ),
              onPressed: () {
                // Handle notification action
              },
            ),
          ],
        ),
        drawer: CustomNavDrawer(),
        body:GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = !_isSearching;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: Text("Search Subject..."),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchPage()));
                      },
                    ),
                  ),
                  SizedBox(height: 16), // Space between search bar and heading
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Semister ${APIs.me!.semester}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                      child: _subCardList(APIs.semSubjectName?.ece ?? [])
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _subCardList(List<String> eceList) {
    if(eceList.isEmpty){
      return Expanded(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 100,left: 50,right: 50),
            width: double.infinity,
            height: 600,
            child: Center(
              child: Column(
                children: [
                  Lottie.asset('assets/animation/nodatafound.json'),
                  SizedBox(height: 20,),
                  Container(width: double.infinity ,child: Center(child: Text("✏️ NO DATA FOUND!!" ,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),))),
                ],
              ),
            ),
          ),
        ),
      );
    }else
    return Column(
      children: eceList.map((subName) {
        return _subCard(subName);
      }).toList(),
    );
  }

  Widget _subCard(String subName) {
    List<String> parts = subName.split('_');
    String number ="";
    String department ="";
    bool check = false;

    if (parts.length == 2) {
      number = parts[0]; // "1"
      department = parts[1]; // "ECE"
      check = (number == APIs.me!.semester.toString());
    } else {
      print("Invalid format");
    }
    if(check){
      return Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child:
          InkWell(
            onTap: () async{
              var temp = await storage.read(key: "$department");
              if (temp != null) {
                Map<String, dynamic> tempJson = json.decode(temp);
                SpecificSubject specificSubject = SpecificSubject.fromJson(tempJson);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubjectDetail(subject: specificSubject),
                  ),
                );
              } else {
                Dialogs.showSnackbar(context, "No data found");
              }
            },

            child: Card(
              color: Color.fromRGBO(232, 229, 239, 1),
              child: ListTile(
                leading: IconButton(
                  icon: SvgPicture.asset(
                    "assets/svgIcons/file.svg",
                  ),
                  onPressed: () {
                    // Handle drawer opening

                  },
                ),
                title: Text(department ,style: GoogleFonts.epilogue(
                  textStyle: TextStyle(
                    color: Constants.BLACK,
                    fontWeight: FontWeight.bold,
                  ),
                ),),
                subtitle: Text("${10 + random.nextInt(51)} Files"),
                trailing: IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.more_vert),
                ),
              ),
            ),
          )
      );
    }else{
      return Container();
    }
  }
}
