import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/models/chatuser.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User get user=> auth.currentUser!;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }


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
}
