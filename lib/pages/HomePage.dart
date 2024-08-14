import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:untitled1/pages/SearchPage.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/custom_helpr.dart';
import 'package:untitled1/database/Apis.dart';
import 'package:untitled1/database/Locals.dart';
import 'package:untitled1/models/SemViseSubModel.dart';
import 'package:untitled1/models/SpecificSubjectModel.dart';
import 'package:untitled1/models/recentsModel.dart';
import 'package:untitled1/pages/ProfilePage.dart';
import 'package:untitled1/pages/RecentsPage.dart';
import 'package:untitled1/pages/Subject_detail.dart';
import 'package:untitled1/pages/sem_vise_subjects.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:untitled1/components/Custom_navDrawer.dart';
import 'OpenPdf.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool issearch = false;
  String _searchText = "";
  final List<Recents> _searchList = [];
  late List<Recents> _findFromSearchList = [];
  final storage = FlutterSecureStorage();
  List<Recents> _list = [];
  late GlobalKey<RefreshIndicatorState> refreshKey;
  List<String> eceList =[];
  Random random = Random();


  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }


  Future<void> _initializeData() async {
    await APIs.offlineInfo();
    await LOCALs.MakeSearchFunctionality();
    // _findFromSearchList = await LOCALs.finalSeachDataList?? [];
    String branchName = APIs.me!.branch!;
    if(branchName == "ECE"){
      eceList = await APIs.semSubjectName?.ece ?? [];
    }else if(branchName == "ITBI"){
      eceList = await APIs.semSubjectName?.itBi ?? [];
    }else{
      eceList = await APIs.semSubjectName?.it ?? [];
    }

  }

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    await APIs.fetchAllSubjects();
    await APIs.fetchSemSubjectName();
    setState(() {
      eceList = APIs.semSubjectName?.ece ?? [];
    });

  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: _handleRefresh,

      child: FutureBuilder(
        future: _initializeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                // child: CircularProgressIndicator(),
                child: _buildShimmer(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              // drawerEnableOpenDragGesture: false,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  'HomePage',
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
                    },
                  ),
                ],
              ),
              drawer: CustomNavDrawer(),
              body: GestureDetector(
                onTap: () => Focus.of(context).unfocus(),
                child: WillPopScope(
                  onWillPop: () {
                    if (issearch) {
                      // setState(() {
                      //     issearch = false;
                      //   _searchList.clear();
                      // });
                      return Future.value(false);
                    } else {
                      return Future.value(true);
                    }
                  },
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: ListTile(
                            leading: Icon(Icons.search),
                            title: Text("Search Subject..."),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchPage()));
                            },
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 16.0),
                        //   child: InkWell(
                        //     onTap: (){
                        //       setState(() {
                        //       });
                        //     },
                        //     child: Container(
                        //       height: 50,
                        //       width: double.infinity,
                        //       child: Text("Search Subject here"),
                        //     ),
                        //   )
                        // ),
                            SizedBox(height: 20),
                            Text(
                             "Subjects",
                              style: GoogleFonts.epilogue(
                                textStyle: TextStyle(
                                  color: Constants.BLACK,
                                  fontWeight: FontWeight.bold,
                                ),
                                fontSize: 25,
                              ),
                            ),
                            Expanded(
                                child: _subCardList()
                            ),
                            // SingleChildScrollView(
                            //   child: Column(
                            //     children: [
                            //       ListView.builder(
                            //         physics: NeverScrollableScrollPhysics(),
                            //         shrinkWrap: true,
                            //         itemCount: _searchList.length,
                            //         itemBuilder: (context, index) {
                            //           return _fileCard(_searchList[index]);
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Text(
                              "My Files",
                              style: GoogleFonts.epilogue(
                                textStyle: TextStyle(
                                  color: Constants.BLACK,
                                  fontWeight: FontWeight.bold,
                                ),
                                fontSize: 25,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
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
                                          child: Text(
                                            "Recently used ￬",
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => RecentsPage()));
                                    },
                                    child: Text(
                                      "See all",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FutureBuilder(
                              future: LOCALs.fetchRecents(),
                              builder: (context, snapshot) {
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
                              },
                            )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _subCardList() {
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
    String number = "";
    String department = "";
    bool check = true;


    if (parts.length == 2) {
      number = parts[0]; // "1"
      department = parts[1];
      check = (number == APIs.me!.semester.toString());
    } else {
      print("Invalid format");
    }
    if(check){
      return InkWell(
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Container(
            color: Colors.white,
            child: Container(
              height: 180,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
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
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      department,
                      style: GoogleFonts.epilogue(
                        textStyle: TextStyle(
                          color: Constants.BLACK,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "${10 + random.nextInt(51)} files",
                      style: GoogleFonts.epilogue(
                        textStyle: TextStyle(
                          color: Constants.BLACK,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }else{
      return Container();
    }

  }

  Widget _fileCard(Recents temp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: InkWell(
        onTap: (){
          // log("${temp.Type}");
          if(temp.Type == "material" || temp.Type == "papers"){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>OpenPdf(link: temp.URL,)));
          }else{
            try {
              LOCALs.launchURL(temp.URL);
            } catch (e) {
              Dialogs.showSnackbar(context, "Unable to Load Url: Error(${e})");
            }
          }
        },
        child: Card(
          child: ListTile(
            leading: IconButton(
              icon: SvgPicture.asset(
                "assets/svgIcons/file.svg",
              ),
              onPressed: () {

              },
            ),
            title: Text(
              temp.Title,
              style: GoogleFonts.epilogue(
                textStyle: TextStyle(
                  color: Constants.BLACK,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                _showBottomSheet(temp.URL);
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(String URL){
    var mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: mq.height * .01, bottom: mq.height * .05),
            children: [
              // const Text(
              //   'Pick Profile Picture',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              // ),
              Divider(indent: 50,endIndent: 50,color: Colors.grey,thickness: 5,),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                      },
                      // child: Image.asset('assets/blue icons/share-Recovered.png')),
                      child: SvgPicture.asset("assets/svgIcons/file.svg",),),

              ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * .3, mq.height * .15),),
                    onPressed: () async {
                    const String url = 'https://drive.google.com/uc?id=1VFA_L6lxChyR6xOvI258S6H1ZrHYJwbN';
                    try {
                      var dir = await getApplicationDocumentsDirectory();
                      String savePath = "${dir.path}/downloaded.pdf";

                      Dio dio = Dio();
                      await dio.download(url, savePath);

                      // log("File downloaded at $savePath");
                    // Open the file using a PDF viewer package
                    } catch (e) {
                       // log("Error downloading file: $e");
                    }
              },
                  child: Image.asset("assets/svgIcons/download.png"),
              )


          // child: Image.asset('assets/blue icons/download-Recovered.png'))
                ],
              )
            ],
          );
        });
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0 ,vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Row(
                 children: [
                   IconButton(
                     icon: SvgPicture.asset(
                       "assets/svgIcons/hamburger.svg",
                       color: Constants.BLACK,
                     ),
                     onPressed: () {
                     },
                   ),
                   SizedBox(width: 10,),
                   Text(
                     'Home',
                     style: GoogleFonts.epilogue(
                       textStyle: TextStyle(
                         fontSize: 25,
                         color: Constants.BLACK,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                 ],
               ),
               IconButton(
                  icon: SvgPicture.asset(
                    "assets/svgIcons/notification.svg",
                    color: Constants.BLACK,
                  ),
                  onPressed: () {

                  },
                ),
            ]
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10,),
                Text(
                  "Search subjects...",style: TextStyle(),
                ),
              ],
            ),
            // child: TextField(
            //   decoration: InputDecoration(
            //     hintText: 'Search subjects...',
            //     prefixIcon: Icon(Icons.search),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            //   onChanged: (text) {
            //     // setState(() {
            //     // });
            //     // Implement search logic here
            //   },
            // ),
          ),
          SizedBox(height: 20),
          Text(
            "Subjects",
            style: GoogleFonts.epilogue(
              textStyle: TextStyle(
                color: Constants.BLACK,
                fontWeight: FontWeight.bold,
              ),
              fontSize: 25,
            ),
          ),
          SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) => _buildSubCardShimmer()),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "My Files",
            style: GoogleFonts.epilogue(
              textStyle: TextStyle(
                color: Constants.BLACK,
                fontWeight: FontWeight.bold,
              ),
              fontSize: 25,
            ),
          ),
          SizedBox(height: 10),
          _buildFileShimmer(),
        ],
      ),
    );
  }

  Widget _buildSubCardShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 180,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  color: Color.fromRGBO(232, 229, 239, 1),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 100,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: 5),
              Container(
                width: 50,
                height: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileShimmer() {
    return Column(
      children: List.generate(3, (index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      )),
    );
  }

}