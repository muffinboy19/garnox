import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/pages/ProfilePage.dart';
import 'package:untitled1/utils/contstants.dart';

import '../database/Apis.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final semesterController = TextEditingController();
  final nameController = TextEditingController();
  final collegeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // Light or dark depending on background color
    ));
  }

  @override
  void dispose() {
    emailController.dispose();
    semesterController.dispose();
    nameController.dispose();
    collegeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = 120;
    double screenWidth = MediaQuery.of(context).size.width;
    double leftPosition = (screenWidth - containerWidth) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.APPCOLOUR,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.epilogue(
            textStyle: TextStyle(
              color: Constants.WHITE,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProfilePage()));
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/svgIcons/notification.svg",
              color: Constants.WHITE,
            ),
            onPressed: () {
              // Handle notification action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //-----------------------------profile image-----------------------------------//
          Container(
            width: double.infinity,
            height: 200,
            color: Constants.WHITE,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    color: Constants.APPCOLOUR,
                  ),
                ),
                Positioned(
                  top: 80,
                  left: leftPosition,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      width: containerWidth,
                      height: containerWidth,
                      color: Constants.WHITE,
                      child: Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Container(
                            child: CachedNetworkImage(
                              imageUrl: APIs.me!.imageUrl!,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter:
                                      ColorFilter.mode(Constants.APPCOLOUR, BlendMode.colorBurn)),
                                ),
                              ),
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          //-----------------------------Edit Profile button----------------------------//
          Container(
            width: double.infinity,
            height: 40,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 110),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (){},
                child: Text("Change Picture",style: TextStyle(color: Colors.white),),
              ),
            ),
          ),

          //---------------------------Enter Fields------------------------------------------------------//
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                key: ValueKey('firstName'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "${APIs.me?.name}",
                  hintStyle: TextStyle(color: Colors.black ),
                  labelStyle: TextStyle(color: Colors.black), // label text color
                ),
                style: TextStyle(color: Colors.black), // input text color
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Invalid name";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                key: ValueKey('Email'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "${APIs.me!.email}",
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black), // label text color
                ),
                style: TextStyle(color: Colors.black), // input text color
                validator: (value) {
                  if (!(value.toString().contains("@"))) {
                    return 'Invalid Email';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: collegeController,
                key: ValueKey('college'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "${APIs.me!.college}",
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black), // label text color
                ),
                style: TextStyle(color: Colors.black), // input text color
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Invalid name";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: semesterController,
                obscureText: true,
                key: ValueKey('Password'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Sem ${APIs.me!.semester.toString()}",
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black), // label text color
                  // suffixIcon:
                  // Icon(Icons.emoji_events_outlined, color: Colors.black), // add your desired icon here
                ),
                style: TextStyle(color: Colors.black), // input text color
                validator: (value) {
                  if (value.toString().trim().length == 1) {
                    return 'Invalid Semester';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Show progress indicator
                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (BuildContext context) {
                      //     return Center(
                      //       child: CircularProgressIndicator(
                      //         color: Colors.blue, // Set the color to blue
                      //       ),
                      //     );
                      //   },
                      // );

                  //     try {
                  //       // // Perform the signup operation
                  //       // await APIs.signup(
                  //       //   emailController.text.trim(),
                  //       //   passwordController.text.trim(),
                  //       //   firstNameController.text.trim(),
                  //       //   lastNameController.text.trim(),
                  //       // );
                  //
                  //       // Dismiss the progress indicator
                  //       // Navigator.pop(context);
                  //       //
                  //       // // Navigate to the home screen
                  //       // Navigator.pushReplacement(
                  //       //   context,
                  //       //   MaterialPageRoute(builder: (_) => Home()),
                  //       // );
                  //     } catch (error) {
                  //       // Dismiss the progress indicator
                  //     //   Navigator.pop(context);
                  //     //
                  //     //   // Show an error message (this can be customized)
                  //     //   showDialog(
                  //     //     context: context,
                  //     //     builder: (BuildContext context) {
                  //     //       return AlertDialog(
                  //     //         title: Text('Error'),
                  //     //         content: Text(error.toString()),
                  //     //         actions: <Widget>[
                  //     //           TextButton(
                  //     //             onPressed: () {
                  //     //               Navigator.of(context).pop();
                  //     //             },
                  //     //             child: Text('OK'),
                  //     //           ),
                  //     //         ],
                  //     //       );
                  //     //     },
                  //     //   );
                  //     // }
                  //   // } else {
                  //     // Show error dialog if form is not valid
                  //     // showDialog(
                  //     //   context: context,
                  //     //   builder: (BuildContext context) {
                  //     //     return AlertDialog(
                  //     //       title: Text('Error'),
                  //     //       content: Text(
                  //     //           'Please fix the errors in the form before submitting.'),
                  //     //       actions: <Widget>[
                  //     //         TextButton(
                  //     //           onPressed: () {
                  //     //             Navigator.of(context).pop();
                  //     //           },
                  //     //           child: Text('OK'),
                  //     //         ),
                  //     //       ],
                  //     //     );
                  //     //   },
                  //     // );
                  //   // }
                  // },
                  }},
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0x000000)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ), // Add some space at the bottom
            ],
          ),
          
        )


      )
        ],
      ),
    );
  }

}