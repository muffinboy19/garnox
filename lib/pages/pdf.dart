import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFViewer extends StatefulWidget {
  final String url;
  final int sem;
  final String subjectCode;
  final String typeKey;
  final int uniqueID;
  final String title;

  PDFViewer({
    required this.url,
    required this.sem,
    required this.subjectCode,
    required this.typeKey,
    required this.uniqueID,
    required this.title,
  });

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  bool isLoading = true;
  late String filePath;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadDocument() async {
    try {
      String url = widget.url;
      final fileID = widget.uniqueID;
      String dir = (await getApplicationDocumentsDirectory()).path;
      String fileName = '${widget.sem}_${widget.subjectCode}_${widget.typeKey[0]}_${fileID}_${Uri.encodeFull(widget.title)}.pdf';
      filePath = '$dir/$fileName';
      File file = File(filePath);

      if (await file.exists()) {
        setState(() {
          isLoading = false;
        });
      } else {
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
          setState(() {
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load PDF: ${response.statusCode}');
        }
      }
    } catch (err) {
      print("Error loading PDF: $err");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : PDFView(
        filePath: filePath,
      ),
    );
  }
}
