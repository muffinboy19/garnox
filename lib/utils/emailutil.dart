import 'package:url_launcher/url_launcher.dart';

class Email {
  String? emailaddress;
  String? subject;
  String? body;

  Email({this.emailaddress, this.subject, this.body});

  // A function to launch email intent in the phone.
  void launchEmail() async {
    final url = Uri.encodeFull("mailto:$emailaddress?subject=$subject&body=$body");
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
