import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/addButton.dart';
import 'package:untitled1/components/custom_loader.dart';
import 'package:untitled1/components/error_animatedtext.dart';
import 'package:untitled1/components/nocontent_animatedtext.dart';
import 'package:untitled1/pages/admin.dart';
import 'package:untitled1/utils/contstants.dart';
import 'package:untitled1/utils/unicorndial_edited.dart';
import 'package:intl/intl.dart';

String selectedOption = 'Materials';

class SubjectsAdmin extends StatefulWidget {
  SubjectsAdmin({required this.subjectCode, required this.canManageModerators});
  final String subjectCode;
  final bool canManageModerators;
  @override
  _SubjectsAdminState createState() => _SubjectsAdminState();
}

class _SubjectsAdminState extends State<SubjectsAdmin> {
  List<String> list = [
    'Materials',
    'Q - Papers',
    'Imp. Links',
    'Books',
    'Moderators'
  ];

  get canManageModerators => null;
  void addBookBottomSheet(BuildContext context, dynamic element) {
    String bookName = '';
    String author = '';
    String publication = '';

    if (element != null) {
      bookName = element['BookTitle'] ?? '';
      author = element['Author'] ?? '';
      publication = element['Publication'] ?? '';
    }

    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (builder) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          height: MediaQuery.of(context).size.height / 2 +
              MediaQuery.of(context).viewInsets.bottom,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(24.0),
              topRight: const Radius.circular(24.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 6,
                      width: 64,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Add a Book",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: bookName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Book Name',
                          labelText: 'Book Name',
                        ),
                        onChanged: (value) {
                          bookName = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: author,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Authors',
                          labelText: 'Authors',
                        ),
                        onChanged: (value) {
                          author = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: publication,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Publication',
                          labelText: 'Publication',
                        ),
                        onChanged: (value) {
                          publication = value;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('Subjects')
                            .doc(widget.subjectCode) // Assuming widget.subjectCode is accessible here
                            .update({
                          'Recommended Books': FieldValue.arrayUnion([
                            {
                              'BookTitle': bookName ?? '',
                              'Author': author ?? '',
                              'Publication': publication ?? ''
                            }
                          ])
                        })
                            .then((_) {
                          Navigator.of(context).pop();
                        })
                            .catchError((error) {
                          print("Error updating document: $error");
                          // Handle error
                        });
                      },
                      child: ElevatedButton(
                        onPressed: null,
                        child: Text('Add Book'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void addImpLinkBottomSheet(BuildContext context, dynamic element) {
    String title = '';
    String url = '';

    if (element != null) {
      title = element['Title'] ?? '';
      url = element['Content URL'] ?? '';
    }

    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: MediaQuery.of(context).size.height / 2 +
                  MediaQuery.of(context).viewInsets.bottom,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24.0),
                  topRight: const Radius.circular(24.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 6,
                          width: 64,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Add the Link",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: title,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Title',
                              labelText: 'Title',
                            ),
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: url,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'URL',
                              labelText: 'URL',
                            ),
                            onChanged: (value) {
                              setState(() {
                                url = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('Subjects')
                                  .doc(widget.subjectCode) // Ensure widget.subjectCode is accessible
                                  .update({
                                'Important Links': FieldValue.arrayUnion([
                                  {
                                    'Content URL': url ?? '',
                                    'Title': title ?? '',
                                  }
                                ])
                              })
                                  .then((_) {
                                Navigator.of(context).pop();
                              })
                                  .catchError((error) {
                                print("Error updating document: $error");
                                // Handle error
                              });
                            },
                            child: ElevatedButton(
                              onPressed: null,
                              child: Text('Add Link'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }



  void addQPapersBottomSheet(BuildContext context, dynamic element) {
    String title = '';
    String type = '';
    String year = '';
    String url = '';

    if (element != null) {
      title = element['Title'] ?? '';
      type = element['Type'] ?? '';
      year = element['Year'] ?? '';
      url = element['URL'] ?? '';
    }

    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              height: MediaQuery.of(context).size.height / 2 +
                  MediaQuery.of(context).viewInsets.bottom,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24.0),
                  topRight: const Radius.circular(24.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 6,
                          width: 64,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Add QPaper",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: title,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Title',
                              labelText: 'Title',
                            ),
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: type,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Exam Type - C1/C2/C3..',
                              labelText: 'Exam Type',
                            ),
                            onChanged: (value) {
                              setState(() {
                                type = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: year,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Year',
                              labelText: 'Year',
                            ),
                            onChanged: (value) {
                              setState(() {
                                year = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: url,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'URL',
                              labelText: 'URL',
                            ),
                            onChanged: (value) {
                              setState(() {
                                url = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              DateTime now = DateTime.now();
                              FirebaseFirestore.instance
                                  .collection('Subjects')
                                  .doc(widget.subjectCode) // Ensure widget.subjectCode is accessible
                                  .update({
                                'QuestionPapers': FieldValue.arrayUnion([
                                  {
                                    'id': DateFormat("yyMMddHHmmss").format(now),
                                    'Title': title ?? '',
                                    'Type': type ?? '',
                                    'URL': url ?? '',
                                    'Year': year ?? ''
                                  }
                                ])
                              })
                                  .then((_) {
                                Navigator.of(context).pop();
                              })
                                  .catchError((error) {
                                print("Error updating document: $error");
                                // Handle error
                              });
                            },
                            child: ElevatedButton(
                              onPressed: null,
                              child: Text('Add QPaper'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  void addMaterialBottomSheet(BuildContext context, dynamic element) {
    String title = '';
    String url = '';

    if (element != null) {
      title = element['Title'] ?? '';
      url = element['Content URL'] ?? '';
    }

    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              height: MediaQuery.of(context).size.height / 2 +
                  MediaQuery.of(context).viewInsets.bottom,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24.0),
                  topRight: const Radius.circular(24.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 6,
                          width: 64,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Add Material",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: title,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Title',
                              labelText: 'Title',
                            ),
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: url,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'URL',
                              labelText: 'URL',
                            ),
                            onChanged: (value) {
                              setState(() {
                                url = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              DateTime now = DateTime.now();
                              FirebaseFirestore.instance
                                  .collection('Subjects')
                                  .doc(widget.subjectCode) // Ensure widget.subjectCode is accessible
                                  .update({
                                'Material': FieldValue.arrayUnion([
                                  {
                                    'id': DateFormat("yyMMddHHmmss").format(now),
                                    'Title': title ?? '',
                                    'Content URL': url ?? '',
                                  }
                                ])
                              })
                                  .then((_) {
                                Navigator.of(context).pop();
                              })
                                  .catchError((error) {
                                print("Error updating document: $error");
                                // Handle error
                              });
                            },
                            child: ElevatedButton(
                              onPressed: null,
                              child: Text('Add Material'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  void addModeratorBottomSheet(BuildContext context, dynamic element) {
    String name = '';
    String contactNumber = '';
    String uid = '';

    if (element != null) {
      name = element['Name'] ?? '';
      contactNumber = element['Contact Number'] ?? '';
      uid = element['uid'] ?? '';
    }

    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              height: MediaQuery.of(context).size.height / 2 +
                  MediaQuery.of(context).viewInsets.bottom,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24.0),
                  topRight: const Radius.circular(24.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 6,
                          width: 64,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Add Moderator",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Name',
                              labelText: 'Name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: contactNumber,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Contact Number',
                              labelText: 'Contact Number',
                            ),
                            onChanged: (value) {
                              setState(() {
                                contactNumber = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: uid,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'UID',
                              labelText: 'UID',
                            ),
                            onChanged: (value) {
                              setState(() {
                                uid = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              if (name.isNotEmpty && uid.isNotEmpty) {
                                FirebaseFirestore.instance
                                    .collection('Subjects')
                                    .doc(widget.subjectCode)
                                    .update({
                                  'MODERATORS': FieldValue.arrayUnion([
                                    {
                                      'uid': uid,
                                      'Name': name,
                                      'Contact Number': contactNumber ?? '',
                                    }
                                  ]),
                                })
                                    .then((_) {
                                  FirebaseFirestore.instance
                                      .collection('admins')
                                      .doc(uid)
                                      .update({
                                    'subjects_assigned':
                                    FieldValue.arrayUnion([widget.subjectCode]),
                                    'canManageModerators': false
                                  })
                                      .then((_) {
                                    Navigator.of(context).pop();
                                  })
                                      .catchError((error) {
                                    print("Error updating admin document: $error");
                                    // Handle error
                                  });
                                })
                                    .catchError((error) {
                                  print("Error updating subject document: $error");
                                  // Handle error
                                });
                              }
                            },
                            child: ElevatedButton(
                              onPressed: null,
                              child: Text('Add Moderator'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectCode}'),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: DropdownButton<String>(
                iconEnabledColor: Constants.DARK_SKYBLUE,
                underline: Container(),
                value: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value!;
                  });
                },
                items: ['Materials', 'Q - Papers', 'Imp. Links', 'Books', 'Moderators']
                    .map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Subjects')
                  .doc(widget.subjectCode)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text('No data available');
                }
                try {
                  Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
                  List<dynamic>? materialData;
                  if (selectedOption == 'Materials') {
                    materialData = data['Material'];
                  } else if (selectedOption == 'Q - Papers') {
                    materialData = data['QuestionPapers'];
                  } else if (selectedOption == 'Imp. Links') {
                    materialData = data['Important Links'];
                  } else if (selectedOption == 'Books') {
                    materialData = data['Recommended Books'];
                  } else if (selectedOption == 'Moderators') {
                    materialData = data['MODERATORS'];
                  }

                  if (materialData == null || materialData.isEmpty) {
                    return NoContentAnimatedText();
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: materialData.length,
                      itemBuilder: (context, index) {
                        return buildMaterialCard(materialData?[index]);
                      },
                    ),
                  );
                } catch (e) {
                  print('Error: $e');
                  return ErrorAnimatedText(key: null,);
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: UnicornDialer(
        hasNotch: true,
        mainAnimationDuration: 300,
        animationDuration: 230,
        parentButton: Icon(Icons.add_circle_outline),
        finalButtonIcon: Icon(Icons.close),
        childPadding: 12,
        backgroundColor: Colors.white70,
        parentButtonBackground: Constants.DARK_SKYBLUE,
        childButtons: [
          if(canManageModerators)
            UnicornButton(
              labelText: 'Moderators',
              labelColor: Colors.black,
              hasLabel: true,
              currentButton: FloatingActionButton(
                heroTag: null,
                mini: true,
                onPressed: () {
                  addModeratorBottomSheet(context, null);
                },
                backgroundColor: Constants.DARK_SKYBLUE,
                child: ImageIcon(
                  AssetImage('assets/svgIcons/moderators.png'),
                  size: 20,
                ),
              ),
              labelBackgroundColor: Colors.white,
              labelShadowColor: Colors.white,
            ),
          UnicornButton(
            labelText: 'Books',
            labelColor: Colors.black,
            hasLabel: true,
            currentButton: FloatingActionButton(
              heroTag: null,
              mini: true,
              onPressed: () {
                addBookBottomSheet(context, null);
              },
              backgroundColor: Constants.DARK_SKYBLUE,
              child: ImageIcon(
                AssetImage('assets/svgIcons/book.png'),
                size: 20,
              ),
            ),
            labelBackgroundColor: Colors.white,
            labelShadowColor: Colors.white,
          ),
          UnicornButton(
            labelText: 'Important Links',
            labelColor: Colors.black,
            hasLabel: true,
            currentButton: FloatingActionButton(
              heroTag: null,
              mini: true,
              onPressed: () {
                addImpLinkBottomSheet(context, null);
              },
              backgroundColor: Constants.DARK_SKYBLUE,
              child: ImageIcon(
                AssetImage('assets/svgIcons/link.png'),
                size: 20,
              ),
            ),
            labelBackgroundColor: Colors.white,
            labelShadowColor: Colors.white,
          ),
          UnicornButton(
            labelText: 'Material',
            labelColor: Colors.black,
            hasLabel: true,
            currentButton: FloatingActionButton(
              heroTag: null,
              mini: true,
              onPressed: () {
                addMaterialBottomSheet(context, null);
              },
              backgroundColor: Constants.DARK_SKYBLUE,
              child: Icon(Icons.note_add),
            ),
            labelBackgroundColor: Colors.white,
            labelShadowColor: Colors.white,
          ),
          UnicornButton(
            labelText: 'Question Papers',
            labelColor: Colors.black,
            hasLabel: true,
            currentButton: FloatingActionButton(
              heroTag: null,
              mini: true,
              onPressed: () {
                addQPapersBottomSheet(context, null);
              },
              backgroundColor: Constants.DARK_SKYBLUE,
              child: ImageIcon(
                AssetImage('assets/svgIcons/pencil.png'),
                size: 20,
              ),
            ),
            labelBackgroundColor: Colors.white,
            labelShadowColor: Colors.white,
          ),
        ],
        onMainButtonPressed: () {},
      ),
    );
  }

  Widget buildMaterialCard(dynamic element) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Tooltip(
        message: element['Content URL'] ?? '',
        child: Card(
          shadowColor: Color.fromRGBO(0, 0, 0, 0.75),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(
              element['Title'] ?? '',
            ),
            subtitle: Text(
              "${element['Type'] ?? ''} ${element['Year'] ?? ''}\nID: ${element['id'] ?? 'unknown'}",
            ),
            leading: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                if (selectedOption == 'Moderators') {
                  addModeratorBottomSheet(context, element);
                } else if (selectedOption == 'Books') {
                  addBookBottomSheet(context, element);
                } else if (selectedOption == 'Imp. Links') {
                  addImpLinkBottomSheet(context, element);
                } else if (selectedOption == 'Materials') {
                  addMaterialBottomSheet(context, element);
                } else if (selectedOption == 'Q - Papers') {
                  addQPapersBottomSheet(context, element);
                }
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                buildDeleteDialog(context, selectedOption, element, widget.subjectCode); // Ensure 4 arguments
              },
            ),
          ),
        ),
      ),
    );
  }


  Future<void> buildDeleteModeratorDialog(BuildContext context, dynamic element, String uid) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(32.0),
          title: Text(
            "⚠ Confirm Delete",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Do you really want to delete this item?\nThis can't be undone",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('admins')
                    .doc(uid)
                    .update({
                  'subjects_assigned': FieldValue.arrayRemove(
                    [element.toString()],
                  ),
                });

                await FirebaseFirestore.instance
                    .collection('Subjects')
                    .doc(element)
                    .update({
                  'MODERATORS': FieldValue.arrayRemove(
                    [element],
                  ),
                }).then((value) => Navigator.of(context).pop());
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> buildDeleteDialog(BuildContext context, String type, dynamic element, String subjectCode) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(32.0),
          title: Text(
            "⚠ Confirm Delete",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Do you really want to delete this item?\nThis can't be undone",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Subjects')
                    .doc(subjectCode)
                    .update({
                  type: FieldValue.arrayRemove([element])
                }).then((_) {
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
