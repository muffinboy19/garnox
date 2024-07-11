import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/models/SpecificSubjectModel.dart';
import 'package:untitled1/models/chatuser.dart';
import 'package:untitled1/pages/sem_vise_subjects.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled1/pages/subject.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User get user=> auth.currentUser!;                          //google user
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static ChatUser? me;                                                //my info
  static final user_uid = auth.currentUser!.uid;

//--------------FETCH ALL SUBJECTS DATA AND STORE IT INTO LOCAL STORAGE--------------------------------------------//
  static Future<void> fetchAllSubjects() async {
    final storage = new FlutterSecureStorage();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Subjects')
          .get();

      querySnapshot.docs.forEach((doc) async {
        try {
          var jsonData = doc.data();
          var subject = SpecificSubject.fromJson(jsonData);
          var encodedSubject = jsonEncode(subject.toJson());

          await storage.write(key: subject.subjectCode, value: encodedSubject);
          // log("${subject.subjectCode} : ${encodedSubject}");
        } catch (e) {
          print('Error writing to secure storage: $e');
        }}
      );


    }catch(e){
      log("fetchAllSubjects Error: $e");
    }
  }

//-----------------------------check user exists-----------------------------------//
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }


//-----------------------------create user through google-----------------------------------//
  static Future<void> createGoogleUser() async {
    final chatUser = ChatUser(
        uid: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        imageUrl: user.photoURL.toString());

    return await firestore
        .collection('user')
        .doc(user.uid)
        .set(chatUser.toJson());
  }


//-----------------------------check user-----------------------------------//
  static Future<void> createUser(String collName, String id, String email, String name) async {
    try {
      await FirebaseFirestore.instance.collection(collName).doc(id).set({
        'name': name,
        'email': email,
        'uid': id,
      });
    } catch (e) {
      log('Error creating user: $e');
    }
  }


//-----------------------------Signup-----------------------------------//
  static Future<void> signup(String email, String password, String firstname, String lastname) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;
      String name = '$firstname $lastname';

      await createUser("user", uid, email, name);

      await signin(email, password);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log("Weak password");
      } else if (e.code == 'email-already-in-use') {
        log("Email already in use");
      } else {
        log("Firebase Auth Exception: ${e.code}");
      }
    } catch (e) {
      log('Error during signup: $e');
    }
  }


//-----------------------------Sign IN-----------------------------------//
  static Future<void> signin(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      } else {
        log('Firebase Auth Exception: ${e.code}');
      }
    } catch (e) {
      log('Error during signin: $e');
    }
  }


//-----------------------------Google Sign IN-----------------------------------//
  static Future<UserCredential?> googleSignIn()async{
    try{
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      return null;
    }
  }


//-----------------------------Fetch All Semister wise subjects-----------------------------------//

  static Stream<QuerySnapshot<Map<String, dynamic>>> semViseSubjects() {
    try {
      final stream = APIs.firestore.collection('Data')
          .where('yearName', isEqualTo: "2026")
          .snapshots();
      stream.listen((snapshot) {
        for (var doc in snapshot.docs) {
          log("Document data: ${jsonEncode(doc.data())}");
        }
      });
      return stream;
    } catch (e) {
      log("Error getting document stream: $e");
      // Return an empty stream in case of an error
      return const Stream.empty();
    }
  }

//-----------------------------Fetch the user data-------------------------------------------------//
  static Future<void> myInfo() async{
    log("${user_uid}");
    await firestore.collection('user').doc(user_uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log("${me!.imageUrl}");
      } else {
        log("NO SUCH USER FOUND {Failed to load myINFO}");
      }
    });
  }

//-----------------------------Fetch the user data-------------------------------------------------//
  static Future<void> updateCollegeDetails(int batch , String branch , int semester) async{

      try{
        await firestore.collection("user").doc(user_uid).update({
          "batch" : batch,
          "branch" : branch,
          "college" : "IIIT Allahabad",
          "semester" : semester,
        });

        log("College Details Updated");
      }catch(e){
        log("Error in updating college details: ${e}");
      }
  }

}
