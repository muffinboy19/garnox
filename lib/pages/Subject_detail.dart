import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/database/Apis.dart';
import 'package:untitled1/database/Locals.dart';
import 'package:untitled1/models/SpecificSubjectModel.dart';
import 'package:untitled1/utils/contstants.dart';

class SubjectDetail extends StatefulWidget {
  final SpecificSubject subject;

  const SubjectDetail({super.key, required this.subject});

  @override
  State<SubjectDetail> createState() => _SubjectDetailState();
}

class _SubjectDetailState extends State<SubjectDetail> with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Set the number of tabs you need
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Subjects/${widget.subject.subjectCode}',
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
              // Handle drawer opening
            },
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/svgIcons/notification.svg",
                color: Constants.BLACK,
              ),
              onPressed: () {
                // Handle notification action
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0), // Height of the TabBar
            child: TabBar(
              labelColor: Constants.BLACK,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Constants.BLACK,
              tabs: [
                Tab(text: 'Material'),
                Tab(text: 'Question Paper'),
                Tab(text: 'Links'),
              ],
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () async {
              if (_isSearching) {
                setState(() {
                  _isSearching = !_isSearching;
                });
                return false;
              } else {
                return true;
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search subjects...',
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _isSearching = text.isNotEmpty;
                          _searchText = text;
                        });
                        // Implement search logic here
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildTabContent("material"),
                        _buildTabContent("papers"),
                        _buildTabContent("links"),
                      ],
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

  Widget _buildTabContent(String type) {
    List<Widget> items = [];
    if (type == "material") {
      items = widget.subject.material.map((item) => _subCard(item.title, item.contentURL)).toList();
    } else if (type == "papers") {
      items = widget.subject.questionPapers.map((item) => _subCard(item.title, item.url)).toList();
    } else if (type == "links") {
      items = widget.subject.importantLinks.map((item) => _subCard(item.title, item.contentURL)).toList();
    } else {
      return Center(child: Text("No Data Found"));
    }
    return SingleChildScrollView(
      child: Column(
        children: items,
      ),
    );
  }

  Widget _subCard(String title, String type) {
    return InkWell(
      onTap: () async{
          LOCALs.recents(title, type);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 1,
          child: ListTile(
            leading: IconButton(
              icon: SvgPicture.asset(
                "assets/svgIcons/file_individual.svg",
              ),
              onPressed: () {
                // Handle drawer opening
              },
            ),
            title: Text(
              title,
              style: GoogleFonts.epilogue(
                textStyle: TextStyle(
                  color: Constants.BLACK,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Text("12 Files"),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ),
        ),
      ),
    );
  }
}
