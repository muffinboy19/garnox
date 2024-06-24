import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/custom_loader.dart';
import 'package:untitled1/pages/subjects_admin.dart';


/*


developer NOTES :


This page is only accessible by a admin user id



CURRENTLY WE DONT HAVE TO WORK ON THIS FILE





 */

class Admin extends StatefulWidget {
  final String uid;

  const Admin({required this.uid});

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool canManageModerators = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkModeratorManageAccess();
  }

  Future<void> checkModeratorManageAccess() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> adminSnapshot =
      await FirebaseFirestore.instance.collection('admins').doc(widget.uid).get();

      if (adminSnapshot.exists) {
        final adminData = adminSnapshot.data();
        if (adminData != null &&
            adminData.containsKey('canManageModerators') &&
            adminData['canManageModerators'] == true) {
          setState(() {
            canManageModerators = true;
          });
        }
      } else {
        print('Admin data not found for UID: ${widget.uid}');
      }
    } catch (error) {
      print('Error retrieving admin data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('admins').doc(widget.uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data available'));
          }

          // Data is available and exists
          try {
            List<dynamic> subjectAssigned = snapshot.data!.get('subjects_assigned') ?? [];

            List<Widget> listMaterials = subjectAssigned
                .map(
                  (element) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(element.toString()),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => SubjectsAdmin(
                            subjectCode: element.toString(),
                            canManageModerators: canManageModerators,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
                .toList();

            // Adding some space at the end of the list
            listMaterials.add(SizedBox(height: 100));

            return ListView(
              children: listMaterials,
            );
          } catch (error) {
            print('Error building subject list: $error');
            return Center(child: Text('Error building subject list'));
          }
        },
      ),
    );
  }

}
