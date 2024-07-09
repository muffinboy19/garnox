import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/custom_helpr.dart';
import 'package:untitled1/database/Apis.dart';
import 'package:untitled1/pages/Subject_detail.dart';
import 'package:untitled1/pages/subjects_admin.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:untitled1/models/SemViseSubModel.dart';

import '../models/SpecificSubjectModel.dart';

class SemViseSubjects extends StatefulWidget {
  const SemViseSubjects({super.key});

  @override
  State<SemViseSubjects> createState() => _SemViseSubjectsState();
}

class _SemViseSubjectsState extends State<SemViseSubjects> {
  bool _isSearching = false;
  String _searchText = "";
  List<SemViseSubjects> _list = [];
  final List<SemViseSubjects> _searchList = [];
  final storage = new FlutterSecureStorage();

  @override
  void initState(){
    super.initState();

    APIs.fetchAllSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Home',
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
            // Handle drawer opening
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
                      setState(() {
                        _isSearching = text.isNotEmpty;
                        _searchText = text;
                      });
                      // Implement search logic here
                    },
                  ),
                ),
                SizedBox(height: 16), // Space between search bar and heading
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Semister 1",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.semViseSubjects(),
                    builder: (context,snapshots){
                       switch(snapshots.connectionState) {
                         case ConnectionState.waiting:
                         case ConnectionState.none:
                         return const Center(
                           child: CircularProgressIndicator(
                             color: Colors.blue,
                           ),
                         );
                         case ConnectionState.active:
                         case ConnectionState.done:
                         if(snapshots.hasData){
                           final data = snapshots.data?.docs;
                           final _list = data?.map((e) => SemViseSubject.fromJson(e.data())).toList() ?? [];

                           if(_list.isEmpty){
                             return Center(
                               child: Text(
                                 'Home',
                                 style: GoogleFonts.epilogue(
                                   textStyle: TextStyle(
                                     color: Constants.BLACK,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                             );
                           }else{
                             return ListView.builder(
                                 itemCount: _isSearching ? _searchList.length : _list.length,
                                 itemBuilder: (context, index) {
                                    return _subCardList(_list[index].ece ?? []);
                                  }
                             );
                           }
                         }else{
                            return Center(child:Text("Error"));
                         }
                       }
                    },
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _subCardList(List<String> eceList) {
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

    if (parts.length == 2) {
      number = parts[0]; // "1"
      department = parts[1]; // "ECE"
    } else {
      print("Invalid format");
    }
    return
      Padding(padding: EdgeInsets.symmetric(horizontal: 20),
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
            subtitle: Text("12 Files"),
            trailing: IconButton(
              onPressed: (){},
              icon: Icon(Icons.more_vert),
            ),
          ),
        ),
      )
      );

  }

}
