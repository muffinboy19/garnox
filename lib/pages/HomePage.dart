import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/custom_helpr.dart';
import 'package:untitled1/database/Apis.dart';
import 'package:untitled1/database/Locals.dart';
import 'package:untitled1/models/SemViseSubModel.dart';
import 'package:untitled1/models/SpecificSubjectModel.dart';
import 'package:untitled1/models/recentsModel.dart';
import 'package:untitled1/pages/Subject_detail.dart';
import 'package:untitled1/pages/sem_vise_subjects.dart';
import 'package:untitled1/utils/contstants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  String _searchText = "";
  final List<SemViseSubjects> _searchList = [];
  final storage = new FlutterSecureStorage();
  List<Recents> _list =[];
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
      body:
      GestureDetector(
        onTap: ()=> Focus.of(context).unfocus(),
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
          }, child:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20) ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
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
                          // _searchText = text;
                        });
                        // Implement search logic here
                      },
                    ),),
                  SizedBox(height: 20,),
                  Text("Subjects" , style: GoogleFonts.epilogue(
                      textStyle: TextStyle(
                        color: Constants.BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                      fontSize: 25
                  ),),
                  Container(
                    height: 250,
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
                                    scrollDirection: Axis.horizontal,
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

                    ),
                  ),
                  Text("My Files" , style: GoogleFonts.epilogue(
                      textStyle: TextStyle(
                        color: Constants.BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                      fontSize: 25
                  ),),
                  Padding(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black), // Add black border
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Container(
                            height: 25,
                            width: 120,
                            child: Center(
                              child: Text("Recently used ￬" ,style: TextStyle(fontWeight: FontWeight.w500),),
                            ),
                          ),
                        ),
                      )

                  ),
                  FutureBuilder(
                      future: LOCALs.fetchRecents(),
                      builder: (context,snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else if (snapshot.hasData) {
                           _list = snapshot.data!;
                          // log("${snapshot.data}");
                          // return Container();
                          return Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: _list.map((subName) {
                                  return _fileCard(subName);
                                }).toList(),
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: Text("No Files Found"),
                          );
                        }
                      })
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _subCardList(List<String> eceList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: eceList.map((subName) {
          return _subCard(subName);
        }).toList(),
      ),
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
      InkWell(
        onTap: () async {
          var temp = await storage.read(key: "$department");
          Dialogs.showProgressBar(context);

          if (temp != null) {
            Map<String, dynamic> tempJson = json.decode(temp);
            SpecificSubject specificSubject = SpecificSubject.fromJson(tempJson);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubjectDetail(subject: specificSubject),
              ),
            ).then((_) {
              Navigator.pop(context);
            });
          } else {
            Navigator.pop(context);
            Dialogs.showSnackbar(context, "No data found");
          }
        },

        child: Padding(padding: EdgeInsets.symmetric(horizontal: 5 ,vertical: 25),
            child:
            Container(
              color: Colors.white,

              child: Container(
                height: 180,
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child:
                      Container(
                        width: double.infinity,
                        height: 120,
                        color: Color.fromRGBO(232, 229, 239, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(45.0),
                          child: SvgPicture.asset(
                              "assets/svgIcons/file.svg",

                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10) , child: Text(department, style: GoogleFonts.epilogue(
                    textStyle: TextStyle(
                      color: Constants.BLACK,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                    ),),),
                    Padding(padding: EdgeInsets.all(0) ,
                        child: Text("12 files", style: GoogleFonts.epilogue(
                        textStyle: TextStyle(
                        color: Constants.BLACK,
                        ),
                    )),)

                  ],
                ),
              ),
            )
        ),
      );

  }

  // Future<Widget> _subFileList() async{
  //   List<Recents>list = await LOCALs.fetchRecents();
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: Column(
  //       children: list.map((subName) {
  //         return _fileCard(subName);
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _fileCard(Recents temp) {
    return
      Padding(padding: EdgeInsets.symmetric(horizontal: 0),
          child:
          InkWell(
            onTap: () async{},

            child: Card(
              child: ListTile(
                leading: IconButton(
                  icon: SvgPicture.asset(
                    "assets/svgIcons/file.svg",
                  ),
                  onPressed: () {
                    // Handle drawer opening

                  },
                ),
                title: Text(temp.Title,style: GoogleFonts.epilogue(
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
