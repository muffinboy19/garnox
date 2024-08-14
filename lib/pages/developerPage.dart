import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/contstants.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {

  String url = "https://i.pinimg.com/originals/a0/e5/8c/a0e58c3357e163667ef29cd152d9556f.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: double.infinity,
                  height: 80,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Constants.APPCOLOUR,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/svgIcons/applogo.svg',
                          color: Constants.WHITE,
                          height: 40, // Adjust height as needed
                          width: 40, // Adjust width as needed
                        ),
                        SizedBox(width: 20),
                        Text(
                          'SEMBREAKER',
                          style: GoogleFonts.epilogue(
                            textStyle: TextStyle(
                              fontSize: 30,
                              color: Constants.WHITE,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'Meet Our Team',
                    style: GoogleFonts.epilogue(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: Constants.BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Column(
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _devimage(url, "Lord Naitik", "Tech Lead"),
                        _devimage(url, "Yojit Kapoor", "Manager"),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _devimage(url, "Mukund Narayan Jha", "UI/Ux Designeer"),
                        _devimage(url, "Vansh Dhawan", "Pole Dancer"),
                      ],
                    )
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'About',
                    style: GoogleFonts.epilogue(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: Constants.BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'Hola Friends, it’s a common scene on the night before the examinations, we the students knock at each of our topper’s door to get his/her notes and waste a lot of our precious time in doing that. What if there is a central place where you would get all the magical notes and material to pass the papers, the destination is here, the SemBreaker App. Sounds fun Right ?',
                    style: GoogleFonts.epilogue(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Constants.BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 500,
                decoration: BoxDecoration(
                  color: Constants.BLACK,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      decoration: BoxDecoration(
                        color: Constants.APPCOLOUR,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: double.infinity,
                      height: 200,
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Text(
                        'Join \nIIITA Community \nnow',
                        style: GoogleFonts.epilogue(
                          textStyle: TextStyle(
                            fontSize: 35,
                            color: Constants.WHITE,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          const url = 'https://www.instagram.com/geekhaven_iiita/?hl=en';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            // You can show an error message or log the error
                            throw 'Could not launch $url';
                          }
                        },
                        child: Text(
                          "Join",
                          style: TextStyle(color: Constants.WHITE, fontSize: 25),
                        ),
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
                    // Add
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Text(
                  'Made with ❤️ By Geek Heaven',
                  style: GoogleFonts.epilogue(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: Constants.BLACK,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _devimage(String URL, String Name, String Position){
    return  Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 100,
            width: 100,
            child: CachedNetworkImage(
              imageUrl: URL,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter:
                      ColorFilter.mode(Colors.white, BlendMode.colorBurn)),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Text(
          Name,
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
              fontSize: 15,
              color: Constants.BLACK,
              fontWeight: FontWeight.bold,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          Position,
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
              fontSize: 15,
              color: Constants.BLACK,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
