import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled1/models/recentsModel.dart';

class LOCALs{

    static final local_storage = new FlutterSecureStorage();

    //-------------------Store the Recents Documents------------------------//
    static void recents(String title, String url) async {

      // Read the existing list from storage
      String? stringOfItems = await local_storage.read(key: 'recents');
      if (stringOfItems != null) {
        List<dynamic> listOfItems = jsonDecode(stringOfItems);

        Map<String, String> newItem = {'Title': title, 'URL': url};
        listOfItems.add(newItem);

        // Writing the updated list back to storage
        await local_storage.write(key: 'recents', value: jsonEncode(listOfItems));

        // Reading the updated list for verification
        String? updatedStringOfItems = await local_storage.read(key: 'recents');
        List<dynamic> updatedListOfItems = jsonDecode(updatedStringOfItems!);
        //
        log("${updatedListOfItems}");
      }else{
        List<Map<String,String>> listOfItems = [];

        Map<String, String> newItem = {'Title': title, 'URL': url};
        listOfItems.add(newItem);

        // Writing the updated list back to storage
        await local_storage.write(key: 'recents', value: jsonEncode(listOfItems));

        // Reading the updated list for verification
        String? updatedStringOfItems = await local_storage.read(key: 'recents');
        List<dynamic> updatedListOfItems = jsonDecode(updatedStringOfItems!);
        //
        log("${updatedListOfItems}");
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
}