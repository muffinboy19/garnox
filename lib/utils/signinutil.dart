import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/models/user.dart' as model;
import 'package:untitled1/utils/sharedpreferencesutil.dart';
import 'contstants.dart';

class SignInUtil {
  SignInUtil({this.college = '', this.batch = 0, this.branch = '', this.semester = 0});
  late String name;
  late String email;
  late String imageUrl;
  String college;
  int batch;
  int semester;
  String branch;
  late String uid;

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final CollectionReference _firestoreUser = FirebaseFirestore.instance.collection(Constants.COLLECTION_NAME_USER);

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      throw Exception('Google Sign-In aborted');
    }
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final auth.UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
    final auth.User firebaseUser = authResult.user!;

    assert(firebaseUser.email != null);
    assert(firebaseUser.displayName != null);
    assert(firebaseUser.photoURL != null);
    assert(firebaseUser.uid != null);

    name = firebaseUser.displayName!;
    email = firebaseUser.email!;
    imageUrl = firebaseUser.photoURL!;
    uid = firebaseUser.uid;

    model.User user = model.User(
      name: name,
      email: email,
      imageUrl: imageUrl,
      uid: uid,
      batch: batch,
      branch: branch,
      college: college,
      semester: semester,
    );

    await SharedPreferencesUtil.setBooleanValue(Constants.USER_LOGGED_IN, true);
    await SharedPreferencesUtil.setStringValue(Constants.USER_DETAIL_OBJECT, user.toJson());

    final DocumentReference userDoc = _firestoreUser.doc(uid);
    final DocumentSnapshot docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
        'uid': uid,
        'batch': batch,
        'branch': branch,
        'college': college,
        'semester': semester,
      });
    }

    return 'signInWithGoogle succeeded: $firebaseUser';
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    await SharedPreferencesUtil.clearPreferences();
  }
}
