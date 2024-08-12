import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import '../database/Locals.dart';
import '../models/recentsModel.dart';
import '../utils/contstants.dart';

class RecentsPage extends StatefulWidget {
  const RecentsPage({super.key});

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  final storage = FlutterSecureStorage();
  bool _isSearching = false;
  List<Recents> _list = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      if (await Permission.storage.request().isGranted) {
        log("Storage permission granted");
      } else {
        log("Storage permission denied");
      }
    } else {
      log("Storage permission already granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Recents',
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
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                  });
                  // Implement search logic here
                },
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _fileCard(Recents temp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: InkWell(
        onTap: () async {},
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

  void _showBottomSheet(String url) {
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
                    await _downloadFile(url);
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

  Future<void> _downloadFile(String url) async {
    Dio dio = Dio();
    Directory? downloadsDirectory;

    if (Platform.isAndroid) {
      downloadsDirectory = await getExternalStorageDirectory();
      if (downloadsDirectory != null) {
        final downloadPath = downloadsDirectory.path;
        final fileName = url.split('/').last.split('?').first; // Extract a valid file name
        final path = '$downloadPath/$fileName';

        try {
          await dio.download(
            url,
            path,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                log("Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
              }
            },
          );
          log("Downloaded to: $path");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Download completed: $path")),
          );
        } catch (e) {
          log("Error downloading: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error downloading: $e")),
          );
        }
      }
    } else {
      downloadsDirectory = await getApplicationDocumentsDirectory();
      if (downloadsDirectory != null) {
        final path = '${downloadsDirectory.path}/${url.split('/').last}';
        try {
          await dio.download(
            url,
            path,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                log("Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
              }
            },
          );
          log("Downloaded to: $path");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Download completed: $path")),
          );
        } catch (e) {
          log("Error downloading: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error downloading: $e")),
          );
        }
      }
    }
  }

}
