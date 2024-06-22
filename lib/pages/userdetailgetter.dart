import 'package:flutter/material.dart';
import 'package:untitled1/components/custom_dropdown.dart';
import 'package:untitled1/utils/contstants.dart'; // Assuming Constants is defined here
import 'signin.dart'; // Adjust path to match your project structure

class UserDetailGetter extends StatefulWidget {
  @override
  _UserDetailGetterState createState() => _UserDetailGetterState();
}

class _UserDetailGetterState extends State<UserDetailGetter> {
  List<String> _branches = ['IT', 'ITBI', 'ECE'];
  List<int> _semester = [1, 2, 3, 4, 5, 6, 7, 8];
  List<int> _batches = [2020, 2019, 2018, 2017, 2016];

  String college = "IIITA";
  int batch = 2019;
  String branch = 'IT';
  int semester = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: 180.0,
                          child: Image.asset('assets/images/Logo.png'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      'Semester',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDropdown(
                      text: "",
                      list: _semester,
                      type: 1,
                      onChanged: (value) {
                        setState(() {
                          semester = value;
                        });
                      }, initialText: 'hello',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      'Batch',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDropdown(
                      text: "",
                      list: _batches,
                      type: 2,
                      onChanged: (value) {
                        setState(() {
                          batch = value;
                        });
                      }, initialText: 'hwllo htis is tet',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      'Branch',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDropdown(
                      text: "",
                      list: _branches,
                      type: 3,
                      onChanged: (value) {
                        setState(() {
                          branch = value;
                        });
                      }, initialText: 'hwllo sss ',
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignIn(
                              college: college,
                              batch: batch,
                              branch: branch,
                              semester: semester,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(36.0),
                        child: Container(
                          height: 50.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              colors: [Constants.DARK_SKYBLUE, Constants.SKYBLUE],
                              stops: [0.0, 1.8],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
}

