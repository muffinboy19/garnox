import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/components/navDrawer.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/pdf.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:untitled1/utils/sharedpreferencesutil.dart';
import 'package:untitled1/components/CustomFlatButton.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  bool admin = false;
  User userLoad = User();
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    fetchUserDetailsFromSharedPref();
    checkIfAdmin();
    listFiles();
  }

  Future<void> fetchUserDetailsFromSharedPref() async {
    var result =
    await SharedPreferencesUtil.getStringValue(Constants.USER_DETAIL_OBJECT);
    if (result != null) {
      Map<String, dynamic> valueMap =
      Map<String, dynamic>.from(json.decode(result));
      User user = User.fromJson(valueMap);
      setState(() {
        userLoad = user;
      });
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

  Future<void> listFiles() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      setState(() {
        files = appDocDir.listSync();
        files.removeWhere((entity) {
          String filename = entity.path.split('/').last;
          return !filename.startsWith(RegExp(r'\d_[A-Z]\w'));
        });
      });
    } catch (error) {
      print('Error listing files: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(userData: userLoad, admin: admin),
      appBar: AppBar(
        title: Text('Downloads'),
      ),
      body: Container(
        child: files.isEmpty
            ? Center(
          child: Text('No downloads'),
        )
            : ListView.builder(
          itemCount: files.length,
          itemBuilder: (BuildContext context, int index) {
            String path = files[index].path;
            String modifiedPath = modifyPath(path);
            List<String> arr = modifiedPath.split('_');
            int uniqueId = int.parse(arr[0]);
            int sem = int.parse(arr[1]);
            String subjectCode = arr[2];
            String typeKey = arr[3];
            String title = arr[4];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Card(
                shadowColor: Color.fromRGBO(0, 0, 0, 0.75),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: ImageIcon(
                    AssetImage('assets/svgIcons/preview.png'),
                    size: 36, // Adjust size as needed
                  ),
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                      '$sem/$subjectCode/${typeKey == 'M' ? 'Material' : 'Q-Paper'}'),
                  trailing: GestureDetector(
                    onTap: () async {
                      try {
                        if (await File(modifiedPath).exists()) {
                          File(modifiedPath).deleteSync();
                          setState(() {
                            files.removeAt(index);
                          });
                        }
                      } catch (err) {
                        print('Error deleting file: $err');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PDFViewer(
                          sem: sem,
                          url: '',
                          subjectCode: subjectCode,
                          typeKey: typeKey,
                          uniqueID: uniqueId,
                          title: title,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String modifyPath(String path) {
    return path.substring(path.indexOf('/'), path.lastIndexOf('\''));
  }
}
