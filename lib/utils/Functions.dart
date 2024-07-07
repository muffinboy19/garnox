import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
@override
_SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchTerm = 'FEE Notes '; // Adjust search term as needed
  List<Map<String, dynamic>> _searchResults = [];DateTime? _requestSentTime;
  DateTime? _responseReceivedTime;
  Duration? _requestDuration;

  Future<void> _searchMaterials() async {
    _requestSentTime = DateTime.now();
    print("Searching for: $_searchTerm at ${_requestSentTime}");

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Subjects')
        .get();

    _responseReceivedTime = DateTime.now();
    _requestDuration = _responseReceivedTime!.difference(_requestSentTime!);
    print("Received response at ${_responseReceivedTime}, took${_requestDuration}");

    setState(() {
      _searchResults = snapshot.docs
          .where((doc) => doc.id.startsWith('1')) // Filter documents starting with '2'
          .map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("Visiting document: ${doc.id}"); // Print the document ID
        if (data.containsKey('Material') && data['Material'] is List) {
          List<dynamic> materials = data['Material'];
          for (var material in materials) {
            if (material is Map && material.containsKey('Title')) {
              String title = material['Title'];
              print("Checking title: $title"); // Print the title being checked
              if (title.toLowerCase().contains(_searchTerm.toLowerCase())) {
                print("Found match: $title");
                return material; // Return the matching material object
              }
            }
          }
        }
        return null; // Return null if no match in this document
      }).whereType<Map<String, dynamic>>().toList(); // Filter out null values

      print("Found${_searchResults.length} results");
    });
  }

  @override
  void initState() {
    super.initState();
    print("initState called");
    _searchMaterials(); // Perform initial search on screen load
  }

  @override
  Widget build(BuildContext context) {
    print("build method called");
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Center(
        child: _searchResults.isEmpty
            ? CircularProgressIndicator() // Show loading indicator while searching
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_requestSentTime != null) Text("Request sent at: ${_requestSentTime}"),
            if (_responseReceivedTime != null) Text("Response received at: ${_responseReceivedTime}"),
            if (_requestDuration != null) Text("Request took: ${_requestDuration}"),
            Text("Found ${_searchResults.length} results"),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  print("Building list item for result: $result");
                  return ListTile(
                    title: Text(result['Title'] ?? ''), // Display the Title of the matching material
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}