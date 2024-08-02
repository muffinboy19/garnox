import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/Custom_navDrawer.dart';
import '../components/custom_helpr.dart';
import '../database/Locals.dart';
import '../models/recentsModel.dart';
import '../utils/contstants.dart';
import 'OpenPdf.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchText = "";
  final List<Recents> _searchList = [];
  late List<Recents> _findFromSearchList = [];
  final storage = FlutterSecureStorage();
  late GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    _findFromSearchList = LOCALs.finalSeachDataList ?? [];
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));
  }

  void _updateSearchResults(String query) {
    setState(() {
      _searchText = query;
      _searchList.clear();
      if (query.isNotEmpty) {
        for (var item in _findFromSearchList) {
          if (item.Title.toLowerCase().contains(query.toLowerCase())) {
            _searchList.add(item);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () {
              return Future.value(true);
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
                        _updateSearchResults(text);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchList.length,
                      itemBuilder: (context, index) {
                        return _fileCard(_searchList[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fileCard(Recents temp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: InkWell(
        onTap: () {
          log("${temp.Type}");
          if (temp.Type == "material" || temp.Type == "papers") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => OpenPdf(link: temp.URL)));
          } else {
            try {
              LOCALs.launchURL(temp.URL);
            } catch (e) {
              Dialogs.showSnackbar(context, "Unable to Load Url: Error($e)");
            }
          }
        },
        child: Card(
          child: ListTile(
            leading: IconButton(
              icon: SvgPicture.asset(
                "assets/svgIcons/file.svg",
              ),
              onPressed: () {},
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
            subtitle: Text("12 Files"),
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

  void _showBottomSheet(String URL) {
    var mq = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: mq.height * .01, bottom: mq.height * .05),
          children: [
            Divider(indent: 50, endIndent: 50, color: Colors.grey, thickness: 5),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                  ),
                  onPressed: () async {},
                  child: SvgPicture.asset("assets/svgIcons/file.svg"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                  ),
                  onPressed: () async {
                    FileDownloader.downloadFile(
                      url: URL,
                      onDownloadCompleted: (value) {
                        log("Downloaded: $value");
                      },
                      onDownloadError: (e) {
                        log("Error in downloading: $e");
                      },
                    );
                  },
                  child: Image.asset("assets/svgIcons/download.png"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
