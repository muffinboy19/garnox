import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database/Locals.dart';
import '../models/recentsModel.dart';
import '../utils/contstants.dart';

class RecentsPage extends StatefulWidget {
  const RecentsPage({super.key});

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  final storage = new FlutterSecureStorage();
  bool _isSearching =false;
  List<Recents> _list =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Recents',
          style: GoogleFonts.epilogue(
            textStyle: TextStyle(
              color: Constants.BLACK,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgIcons/hamburger.svg",
            color: Constants.BLACK,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/svgIcons/notification.svg",
              color: Constants.BLACK,
            ),
            onPressed: () {},
          ),
        ],
      ),
       body: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Expanded(
                 child: Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 16.0),
                       child: TextField(
                         decoration: InputDecoration(
                           hintText: 'Search subjects...',
                           prefixIcon: Icon(Icons.search),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(8.0),
                           ),
                         ),
                         onChanged: (text) {
                           setState(() {
                             _isSearching = text.isNotEmpty;
                             // _searchText = text;
                           });
                           // Implement search logic here
                         },
                       ),),
                     FutureBuilder(
                       future: LOCALs.fetchRecents(),
                       builder: (context,snapshot){
                         if (snapshot.connectionState == ConnectionState.waiting) {
                           return Center(
                             child: CircularProgressIndicator(),
                           );
                         } else if (snapshot.hasError) {
                           return Center(
                             child: Text("Error: ${snapshot.error}"),
                           );
                         } else if (snapshot.hasData) {
                           _list = snapshot.data!;
                           // log("${snapshot.data}");
                           // return Container();
                           return Expanded(
                             child: SingleChildScrollView(
                               scrollDirection: Axis.vertical,
                               child: Column(
                                 children: _list.map((subName) {
                                   return _fileCard(subName);
                                 }).toList(),
                               ),
                             ),
                           );
                         } else {
                           return Center(
                             child: Text("No Files Found"),
                           );
                         }
                       }),
                   ],
                 ),
         ),
       ),
    );
  }

  Widget _fileCard(Recents temp) {
    return
      Padding(padding: EdgeInsets.symmetric(horizontal: 0),
          child:
          InkWell(
            onTap: () async{},

            child: Card(
              child: ListTile(
                leading: IconButton(
                  icon: SvgPicture.asset(
                    "assets/svgIcons/file.svg",
                  ),
                  onPressed: () {
                    // Handle drawer opening

                  },
                ),
                title: Text(temp.Title,style: GoogleFonts.epilogue(
                  textStyle: TextStyle(
                    color: Constants.BLACK,
                    fontWeight: FontWeight.bold,
                  ),
                ),),
                subtitle: Text("12 Files"),
                trailing: IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.more_vert),
                ),
              ),
            ),
          )
      );

  }

}
