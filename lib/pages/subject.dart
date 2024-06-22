import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled1/components/custom_loader.dart';
import 'package:untitled1/components/error_animatedtext.dart';
import 'package:untitled1/components/nocontent_animatedtext.dart';
import 'package:untitled1/pages/pdf.dart';
import 'package:untitled1/utils/unicorndial_edited.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_it/get_it.dart';
import '../utils/contstants.dart';
import 'package:get_it/get_it.dart';


class CallService {
  void call(String number) => launch("tel:$number");
}

GetIt locator = GetIt.asNewInstance();

void set() {
  locator.registerSingleton(CallService());
}

class Subject extends StatefulWidget {
  Subject({required this.semester, required this.subjectCode});

  final int semester;
  final String subjectCode;

  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _hideFabAnimController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );

    _scrollController.addListener(
      () {
        switch (_scrollController.position.userScrollDirection) {
          // Scrolling up - forward the animation (value goes to 1)
          case ScrollDirection.forward:
            _hideFabAnimController.forward();
            break;
          // Scrolling down - reverse the animation (value goes to 0)
          case ScrollDirection.reverse:
            _hideFabAnimController.reverse();
            break;
          // Idle - keep FAB visibility unchanged
          case ScrollDirection.idle:
            break;
        }
      },
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Recommended Books':
        recBooks(context);
        break;
      case 'Moderators':
        modno(context);
        break;
    }
  }

  void modno(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: Constants.WHITE,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(24.0),
              topRight: const Radius.circular(24.0),
            ),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure the column only takes minimum space needed
            children: <Widget>[
              Container(
                height: 6,
                width: 64,
                color: Colors.black45,
              ),
              SizedBox(height: 12),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Subjects')
                    .doc('${widget.semester}_${widget.subjectCode}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                    return Center(child: Text('No data available'));
                  }

                  List<Widget> messageWidgets = [];
                  List<dynamic> mods = snapshot.data!.get('MODERATORS') ?? [];

                  for (int i = 0; i < mods.length; i++) {
                    final ctnum = mods[i]['Contact Number'];
                    final name = mods[i]['Name'];
                    messageWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name ?? '',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              ctnum ?? '',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    // Add a divider between moderators
                    if (i < mods.length - 1) {
                      messageWidgets.add(Divider());
                    }
                  }

                  return Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: messageWidgets,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void recBooks(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: Constants.WHITE,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(24.0),
              topRight: const Radius.circular(24.0),
            ),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure the column only takes minimum space needed
            children: <Widget>[
              Container(
                height: 6,
                width: 64,
                color: Colors.black45,
              ),
              SizedBox(height: 12),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Subjects')
                    .doc('${widget.semester}_${widget.subjectCode}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                    return Center(child: Text('No data available'));
                  }

                  List<Widget> messageWidgets = [];
                  List<dynamic> recBooks = snapshot.data!.get('Recommended Books') ?? [];

                  for (int i = 0; i < recBooks.length; i++) {
                    final author = recBooks[i]['Author'];
                    final bookTitle = recBooks[i]['BookTitle'];
                    final publication = recBooks[i]['Publication'];

                    /*
                    only for now i have put all of these as true adn tehy out to bee changed
                     */

                    messageWidgets.add(ListItem(heading: bookTitle));
                    messageWidgets.add(ListItem(heading: 'Author:', subheaading: author));
                    messageWidgets.add(ListItem(heading: 'Publication:', subheaading: publication));

                    // Add a divider between books
                    if (i < recBooks.length - 1) {
                      messageWidgets.add(Divider());
                    }
                  }

                  return Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: messageWidgets,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _hideFabAnimController.dispose();
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
        floatingActionButton: FadeTransition(
          opacity: _hideFabAnimController,
          child: ScaleTransition(
            scale: _hideFabAnimController,
            child: UnicornDialer(
              backgroundColor: Colors.white70,
              parentButton: ImageIcon(AssetImage('assets/svgIcons/info.png')),
              parentButtonBackground: Constants.DARK_SKYBLUE,
              finalButtonIcon: Icon(Icons.close),
              childPadding: 12,
              childButtons: [
                UnicornButton(
                  labelColor: Colors.black,
                  hasLabel: true,
                  labelText: 'Books',
                  currentButton: FloatingActionButton(
                    heroTag: null,
                    mini: true,
                    onPressed: () {
                      recBooks(context);
                    },
                    backgroundColor: Constants.DARK_SKYBLUE,
                    child: ImageIcon(AssetImage('assets/svgIcons/book.png'),
                        size: 20),
                  ), labelBackgroundColor: Colors.white, labelShadowColor: null,
                ),
                UnicornButton(
                  labelColor: Colors.black,
                  hasLabel: true,
                  labelText: 'Moderators',
                  currentButton: FloatingActionButton(
                    heroTag: null,
                    mini: true,
                    onPressed: () {
                      modno(context);
                    },
                    backgroundColor: Constants.DARK_SKYBLUE,
                    child: ImageIcon(
                        AssetImage('assets/svgIcons/moderators.png'),
                        size: 20),
                  ),
                ),
              ], onMainButtonPressed: () {  },
            ),
          ),
        ),
      ),
    );
  }
}

class StreamWidget extends StatelessWidget {
  const StreamWidget(
      {Key? key,
      required this.widget,
      required this.typeKey,
      required this.scrollController})
      : super(key: key);
  final ScrollController scrollController;
  final Subject widget;
  final String typeKey;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Subjects')
          .doc('${widget.semester}_${widget.subjectCode}')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomLoader(); // Display a loader while waiting for data
        }

        if (snapshot.hasError) {
          print('Firestore snapshot error: ${snapshot.error}');
          return Center(child: Text('Error fetching data'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return NoContentAnimatedText(); // Display message when no data exists
        }

        try {
          final data = snapshot.data!.data() as Map<String, dynamic>;

          List<Map<String, dynamic>> materialData = [];

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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PDFViewer(
                            url: element['Content URL'] ?? '',
                            sem: widget.semester,
                            subjectCode: widget.subjectCode,
                            typeKey: typeKey,
                            uniqueID: int.parse(element['id'].toString()),
                            title: element['Title'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                  trailing: IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/svgIcons/download.png'),
                      size: 20,
                    ),
                    onPressed: () async {
                      try {
                        String url = element['Content URL'] ?? '';
                        String dir = (await getApplicationDocumentsDirectory()).path;
                        String path = "$dir/${widget.semester}_${widget.subjectCode}_${typeKey[0]}_${element['id']}_${element['Title']}";
                        if (await File(path).exists()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('File Already Downloaded'),
                            ),
                          );
                        } else {
                          var request = await HttpClient().getUrl(Uri.parse(url));
                          var response = await request.close();
                          var bytes = await consolidateHttpClientResponseBytes(response);
                          File file = File(path);
                          await file.writeAsBytes(bytes);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Download Complete'),
                            ),
                          );
                        }
                      } catch (err) {
                        print('Error downloading file: $err');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error downloading file'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          }).toList();

          listMaterials.add(SizedBox(height: 100));

          return Container(
            child: ListView(
              controller: scrollController,
              children: listMaterials,
            ),
          );
        } catch (err) {
          print('Error building materials list: $err');
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
  // final CallService _service = locator<CallService>();

  @override
  ListItem({required this.heading,  this.subheaading,  this.b,  this.c,  this.phone});

  String heading;
  String? subheaading;
  // Icon head;
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
                  subheaading!,
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
                    subheaading!,
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
