import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/custom_helpr.dart';
import 'package:untitled1/database/Apis.dart';
import 'package:untitled1/pages/HomePage.dart';
import 'package:untitled1/utils/contstants.dart';

class CollegeDetails extends StatefulWidget {
  const CollegeDetails({super.key});

  @override
  State<CollegeDetails> createState() => _CollegeDetailsState();
}

class _CollegeDetailsState extends State<CollegeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.WHITE,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text("Select Semester",
                style: GoogleFonts.epilogue(
                  fontSize: 30,
                  textStyle: TextStyle(
                    color: Constants.BLACK,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 45,
            width: 180,
            child: ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue, // Set the color to blue
                      ),
                    );
                  },
                );

                try {
                  // Perform the update operation
                  await APIs.updateCollegeDetails(2026, "ITBI", 1);

                  // Dismiss the progress indicator
                  Navigator.pop(context);

                  // Navigate to the home screen
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                } catch (error) {
                  // Dismiss the progress indicator
                  Navigator.pop(context);

                  // Show an error message
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(error.toString()),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Upload", style: TextStyle(color: Constants.WHITE, fontSize: 20),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Constants.APPCOLOUR),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
