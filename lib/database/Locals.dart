import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled1/components/custom_helpr.dart';
import 'package:untitled1/models/recentsModel.dart';
import 'package:url_launcher/url_launcher.dart';

class LOCALs{

    static final local_storage = new FlutterSecureStorage();

    //-------------------Store the Recents Documents------------------------//
    static Future<void> recents(String title, String url, String type) async {

      String? stringOfItems = await local_storage.read(key: 'recents');
      if (stringOfItems != null) {
        List<dynamic> listOfItems = jsonDecode(stringOfItems);

        Map<String, String> newItem = {'Title': title, 'URL': url, 'Type': type};
        listOfItems.add(newItem);

        await local_storage.write(key: 'recents', value: jsonEncode(listOfItems));

        String? updatedStringOfItems = await local_storage.read(key: 'recents');
        List<dynamic> updatedListOfItems = jsonDecode(updatedStringOfItems!);

        log("$updatedListOfItems");
      } else {
        List<Map<String, String>> listOfItems = [];

        Map<String, String> newItem = {'Title': title, 'URL': url, 'Type': type};
        listOfItems.add(newItem);

        await local_storage.write(key: 'recents', value: jsonEncode(listOfItems));

        String? updatedStringOfItems = await local_storage.read(key: 'recents');
        List<dynamic> updatedListOfItems = jsonDecode(updatedStringOfItems!);

        log("$updatedListOfItems");
      }
    }

    //-------------------Fetch ALL Recents Documents from local storage---------//
    static Future<List<Recents>> fetchRecents() async {
      String? stringOfItems = await local_storage.read(key: "recents");
      if (stringOfItems != null) {
        List<dynamic> listOfItems = jsonDecode(stringOfItems);
        return listOfItems.map((item) => Recents.fromJson(item)).toList();
      } else {
        return [];
      }
    }

    //----------------------Launch Url-----------------------------------------//
    /*
          Currently this will not work as permissions are not given
     */
    static Future<void> launchURL(String url) async {
      try {
        if (await canLaunch(url)) {
          await launch(url, forceSafariVC: false);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        log('Error launching URL: $e');
        throw 'Could not launch $url';
      }
    }

}