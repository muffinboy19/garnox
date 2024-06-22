import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/components/navdrawerItem.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/home.dart';
import 'package:untitled1/pages/userdetailgetter.dart';
import 'package:untitled1/utils/sharedpreferencesutil.dart';
import 'package:untitled1/utils/signinutil.dart';
import 'package:untitled1/utils/contstants.dart';
import '../pages/admin.dart';

List<Color> _colors = [Constants.DARK_SKYBLUE, Constants.SKYBLUE];
List<double> _stops = [0.0, 0.9];

class NavDrawer extends StatefulWidget {
  NavDrawer({required this.userData, required this.admin});

  final User userData;
  final bool admin;

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late String name;
  late String email;
  late String uid;
  late String college;
  late int batch;
  late String imageUrl;
  List<String> _branches = ['IT', 'ITBI', 'ECE'];

  late String _selectedBranch;
  late User userLoad;
  Future<void> fetchUserDetailsFromSharedPref() async {
    var result = await SharedPreferencesUtil.getStringValue(Constants.USER_DETAIL_OBJECT);
    if (result != null) {
      try {
        Map<String, dynamic> valueMap = json.decode(result);
        User user = User.fromJson(valueMap);
        setState(() {
          userLoad = user;
        });
      } catch (e) {
        print("Error decoding user details: $e");
      }
    } else {
      print("No user details found in SharedPreferences.");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  widget.userData.name ?? ' ',
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  widget.userData.email ?? ' ',
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: CachedNetworkImage(
                      imageUrl: widget.userData.imageUrl!,
                      fadeInCurve: Curves.easeIn,
                      placeholder: (BuildContext context, String string) {
                        return Icon(Icons.person);
                      },
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: ImageIcon(
                  AssetImage("assets/grey icons/browser.png"),
                  color: (current == 1) ? Constants.DARK_SKYBLUE : Constants.STEEL,
                  size: 22.0,
                ),
                title: Text(
                  "Home",
                  style: TextStyle(
                    color: (current == 1) ? Constants.DARK_SKYBLUE : Constants.STEEL,
                    fontWeight: FontWeight.normal,
                    fontSize: 17.0,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                onTap: () {
                  setState(() {
                    current = 1;
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => Home()),
                    ModalRoute.withName('/'),
                  );
                },
                selected: current == 1,
              ),
              if(widget.admin)
                ListTile(
                  leading: Icon(
                    Icons.developer_mode,
                    color: (current == 6) ? Constants.DARK_SKYBLUE : Constants.STEEL,
                    size: 22.0,
                  ),
                  title: Text(
                    "Admin Panel",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: (current == 6) ? Constants.DARK_SKYBLUE : Constants.STEEL,
                      fontSize: 17.0,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      current = 6;
                    });
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => Admin(uid: widget.userData.uid!)),
                      ModalRoute.withName('/'),
                    );
                  },
                  selected: current == 6,
                ),
              ListTile(
                leading: ImageIcon(
                  AssetImage("assets/grey icons/logout.png"),
                  color: (current == 7) ? Constants.DARK_SKYBLUE : Constants.STEEL,
                  size: 22.0,
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: (current == 7) ? Constants.DARK_SKYBLUE : Constants.STEEL,
                    fontSize: 17.0,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                onTap: () {
                  buildSignOutDialog(context);
                },
                selected: current == 7,
              ),
            ],
          ),
          Positioned(
            top: 50,
            right: 0,
            child: TextButton(
              onPressed: () {
                buildShowModalBottomSheet(context);
              },
              child: ImageIcon(
                AssetImage("assets/grey icons/edit.png"),
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> buildSignOutDialog(BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when "No" is pressed
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true); // Return true when "Yes" is pressed
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Perform sign-out and navigate to the appropriate screen
      await SignInUtil().signOutGoogle(); // Assuming this signs out the user
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => UserDetailGetter()),
        ModalRoute.withName('/'),
      );
    }
  }
  void buildShowModalBottomSheet(BuildContext context) {
    String name = widget.userData.name ?? "";
    String _selectedBranch = widget.userData.branch ?? "";
    Color col = Colors.white;

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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height - 150,
              decoration: BoxDecoration(
                color: Constants.WHITE,
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
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            bottom: 25.0,
                            top: 0.0,
                          ),
                          child: Divider(
                            height: 10.0,
                            color: Colors.blue,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 3.0),
                            child: Text(
                              "Edit Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: widget.userData.name,
                              labelText: 'Name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 3.0),
                            child: Text(
                              "Edit Branch",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                isEmpty: _selectedBranch == widget.userData.branch,
                                child: DropdownButtonHideUnderline(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12.0,
                                      right: 12.0,
                                    ),
                                    child: DropdownButton<String>(
                                      value: _selectedBranch,
                                      isDense: true,
                                      dropdownColor: Colors.white,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedBranch = newValue!;
                                        });
                                      },
                                      items: _branches.map(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            child: Text(value),
                                            value: value,
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('userDetails')
                                .doc(widget.userData.uid)
                                .update({
                              'name': name.isEmpty ? widget.userData.name : name,
                              'branch': _selectedBranch,
                            });
                            await fetchUserDetailsFromSharedPref();
                            userLoad.branch = _selectedBranch;
                            userLoad.name = name.isEmpty ? widget.userData.name : name;

                            await SharedPreferencesUtil.setBooleanValue(
                              Constants.USER_LOGGED_IN,
                              true,
                            );
                            await SharedPreferencesUtil.setStringValue(
                              Constants.USER_DETAIL_OBJECT,
                              userLoad.toString(),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                              ModalRoute.withName("/Home"),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 108, vertical: 36),
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                  colors: _colors,
                                  stops: _stops,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            bottom: 25.0,
                            top: 0.0,
                          ),
                          child: Divider(
                            height: 10.0,
                            color: Colors.blue,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Unique User ID (Tap To Copy)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Clipboard.setData(
                                  ClipboardData(text: widget.userData.uid!),
                                );
                              });
                            },
                            child: DottedBorder(
                              radius: Radius.circular(12),
                              color: Constants.DARK_SKYBLUE,
                              padding: EdgeInsets.all(8),
                              strokeWidth: 1,
                              child: Center(
                                child: Container(
                                  color: col,
                                  child: SelectableText(
                                    widget.userData.uid!,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
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

  Future<List<String>> getShareAppUrl() async {
    try {
      QuerySnapshot snap =
      await FirebaseFirestore.instance.collection("playstoreURL").get();
      if (snap.docs.isNotEmpty) {
        // Cast the data to Map<String, dynamic> before accessing elements
        Map<String, dynamic> data = snap.docs.first.data() as Map<String, dynamic>;
        return [data["msg"] as String, data["link"] as String];
      } else {
        throw Exception("No documents found");
      }
    } catch (e) {
      // Handle error
      print("Error fetching URLs: $e");
      return ["Error", "Error"];
    }
  }
}




