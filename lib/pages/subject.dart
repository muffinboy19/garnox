import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:untitled1/components/custom_loader.dart';
import 'package:untitled1/components/error_animatedtext.dart';
import 'package:untitled1/components/nocontent_animatedtext.dart';
import 'package:untitled1/utils/unicorndial_edited.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/contstants.dart';

class Subject extends StatefulWidget {
  Subject({required this.subjectCode});

  final String subjectCode;

  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    print("asd: ${widget.subjectCode}");
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

  void handleClick(String value) {
    if (value.isEmpty) {
      print("the value here is empty [asd]");
    } else {
      print("the value is not empty [asd]");
    }
    switch (value) {
      case 'Recommended Books':
        break;
      case 'Moderators':
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.DARK_SKYBLUE,
          elevation: 0,
          title: Text(
            '${widget.subjectCode}',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: ImageIcon(AssetImage('assets/svgIcons/book.png')),
                text: 'Material',
              ),
              Tab(
                icon: ImageIcon(AssetImage('assets/svgIcons/pencil.png')),
                text: 'Q. Paper',
              ),
              Tab(
                icon: ImageIcon(AssetImage('assets/svgIcons/link.png')),
                text: 'Links',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamWidget(
              widget: widget,
              typeKey: 'Material',
              scrollController: _scrollController,
            ),
            StreamWidget(
              widget: widget,
              typeKey: 'QuestionPapers',
              scrollController: _scrollController,
            ),
            StreamWidget(
              widget: widget,
              typeKey: 'Important Links',
              scrollController: _scrollController,
            ),
          ],
        ),
      ),
    );
  }
}

class StreamWidget extends StatelessWidget {
  const StreamWidget({
    Key? key,
    required this.widget,
    required this.typeKey,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;
  final Subject widget;
  final String typeKey;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Subjects')
          .doc('${widget.subjectCode}')
          .snapshots(),
      builder: (context, snapshot) {
        print("[nsd] ************************  ${widget.subjectCode}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          print("this means the connections is not yet made  [nsd] ");
          return CustomLoader(); // Display a loader while waiting for data
        }

        if (snapshot.hasError) {
          print('Firestore snapshot error: ${snapshot.error}');
          return Center(child: Text('Error fetching data'));
        }

        if (!snapshot.hasData || snapshot.data == null || snapshot.data?.data() == null) {
          return NoContentAnimatedText(); // Display message when no data exists
        }

        try {
          final data = snapshot.data?.data() as Map<String, dynamic>;

          List<Map<String, dynamic>> materialData = [];
          print("$data         [nsd]  ");

          // Determine which typeKey to use based on your app logic
          if (typeKey == 'Material') {
            materialData = List<Map<String, dynamic>>.from(data['Material'] ?? []);
          } else if (typeKey == 'QuestionPapers') {
            materialData = List<Map<String, dynamic>>.from(data['QuestionPapers'] ?? []);
          } else if (typeKey == 'Important Links') {
            materialData = List<Map<String, dynamic>>.from(data['Important Links'] ?? []);
          }

          // Check if materialData is empty and display appropriate message
          if (materialData.isEmpty) {
            print("no material is present  [asd] ");
            return NoContentAnimatedText();
          }

          // Build list of widgets based on materialData
          List<Widget> listMaterials = materialData.map((element) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    element['Title'] ?? '', // Ensure 'Title' is not null
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: typeKey == 'QuestionPapers'
                      ? Text('${element['Type'] ?? ''} - ${element['Year'] ?? ''}')
                      : null,
                  leading: IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/svgIcons/preview.png'),
                    ),
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => PDFViewer(
                      //       url: element['Content URL'] ?? '',
                      //       sem: widget.semester,
                      //       subjectCode: widget.subjectCode,
                      //       typeKey: typeKey,
                      //       uniqueID: int.parse(element['id'].toString()),
                      //       title: element['Title'] ?? '',
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                  trailing: IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/svgIcons/download.png'),
                      size: 20,
                    ),
                    onPressed: () async {
                      // try {
                      //   String url = element['Content URL'] ?? '';
                      //   String dir = (await getApplicationDocumentsDirectory()).path;
                      //   String path = "$dir/${widget.semester}_${widget.subjectCode}_${typeKey[0]}_${element['id']}_${element['Title']}";
                      //   if (await File(path).exists()) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text('File Already Downloaded'),
                      //       ),
                      //     );
                      //   } else {
                      //     var request = await HttpClient().getUrl(Uri.parse(url));
                      //     var response = await request.close();
                      //     var bytes = await consolidateHttpClientResponseBytes(response);
                      //     File file = File(path);
                      //     await file.writeAsBytes(bytes);
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text('Download Complete'),
                      //       ),
                      //     );
                      //   }
                      // } catch (err) {
                      //   print('Error downloading file: $err');
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text('Error downloading file'),
                      //     ),
                      //}
                    },
                  ),
                ),
              ),
            );
          }).toList();

          // Ensure the SizedBox is wrapped in a Padding widget
          listMaterials.add(Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(height: 100),
          ));

          return Container(
            child: ListView(
              controller: scrollController,
              children: listMaterials,
            ),
          );
        } catch (err) {
          print('Error building materials list    [asd] : $err');
          return ErrorAnimatedText(key: null,); // Display an error message if building the list fails
        }
      },
    );
  }

  Future urlLauncher(url) async {
    {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}


class ListItem extends StatelessWidget {
  @override
  ListItem({required this.heading, this.subheaading, this.b, this.c, this.phone});

  String heading;
  String? subheaading;
  bool? b = false;
  bool? c = false;
  bool? phone = false;

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          getWidget(),
        ],
      ),
    );
  }

  Widget getWidget() {
    if (c == true) {
      return Expanded(
        child: SizedBox(
          height: 10.0,
          width: 200.0,
          child: Divider(
            color: Colors.grey,
            height: 0.0,
            thickness: 0.0,
            indent: 40.0,
            endIndent: 40.0,
          ),
        ),
      );
    }
    if (phone == true) {
      return Text('WhatsApp functionality disabled');
    }

    if (b == true) {
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ImageIcon(
                  AssetImage(
                    'assets/svgIcons/book.png',
                  ),
                  size: 30.0,
                  color: Colors.teal,
                ),
              ),
              Flexible(
                flex: 4,
                child: Text(
                  subheaading ?? 'subheading',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Flexible(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    heading,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    subheaading ?? 'subheading',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
