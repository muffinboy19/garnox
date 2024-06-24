import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SemsiterAskingPage extends StatefulWidget {@override
_SemsiterAskingPageState createState() => _SemsiterAskingPageState();
}

class _SemsiterAskingPageState extends State<SemsiterAskingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedBranch;
  int? selectedSemester;
  List<String> branchNames = [];
  int maxSem = 0;

  @override
  void initState() {
    super.initState();
    fetchBranchNames();
  }

  Future<void> fetchBranchNames() async {
    try{
      QuerySnapshot snapshot = await _firestore.collection('branch').get();
      setState(() {
        branchNames = snapshot.docs.map((doc) => doc['name'] as String).toList();
        print("[FIREBASE] Fetched Branch Names: $branchNames");
      });
    } catch (e) {
      print('[FIREBASE] Error fetching branch names: $e');
      // Handle error appropriately (e.g., show a snackbar)
    }
  }

  Future<void> fetchMaxSem(String branchName) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('branch')
          .where('name', isEqualTo: branchName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          maxSem = snapshot.docs.first['maxSem'] as int;
          selectedSemester = null; // Reset semester selection
          print("[FIREBASE] Fetched maxSem for $branchName: $maxSem");
        });
      }
    } catch (e) {
      print('[FIREBASE] Error fetching maxSem: $e');// Handle error appropriately
    }
  }

  Future<void> saveToSharedPreferences() async {
    if (selectedBranch != null && selectedSemester != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('CurrentUserBranch', selectedBranch!);
      await prefs.setInt('CurrentUserSemester', selectedSemester!);
      print("[SharePref] Saved Branch: $selectedBranch, Semester: $selectedSemester");
    } else {
      // Handle cases where branch or semester is not selected (e.g., show a snackbar)
      print("[SharePref]  ERROR Branch or Semester not selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branch and Semester Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedBranch,
              items: branchNames.map((branchName) {
                return DropdownMenuItem<String>(
                  value: branchName,
                  child: Text(branchName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBranch = value;
                  fetchMaxSem(value!); // Fetch maxSem when branch changes
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Branch',
              ),
            ),
            SizedBox(height: 16),
            if (selectedBranch != null)
              DropdownButtonFormField<int>(
                value: selectedSemester,
                items: List.generate(maxSem, (index) => index + 1)
                    .map((semester) {
                  return DropdownMenuItem<int>(
                    value: semester,
                    child: Text(semester.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSemester = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Semester',
                ),
              ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await saveToSharedPreferences();
                Navigator.pushReplacementNamed(context, '/home'); // Replace '/home' with your actual route
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}