import 'package:digislip/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create custom user object based on Firebase user
  CustomUser? _userFromFirebaseUser(User? user) {
    return user != null ? CustomUser(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream
  Stream<CustomUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // sign in with email and password
  Future SignInEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid: user!.uid, email: user.email!).createUserData();
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch(e) {
      return e;
    }
  }

  // register with email and password
  Future RegisterEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid: user!.uid, email: user.email!)
          .createUserData();
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch(e) {
      return e;
    }
  }

  // reset password
  Future ResetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Email has been sent.';
    } on FirebaseAuthException catch(e) {
      return e;
    }
  }

  // sign in with google
  Future signInWithGoogle() async {
    try {
      // begin interactive sign in
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // obtain auth details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // create new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      await DatabaseService(uid: result.user!.uid, email: result.user!.email!)
          .createUserData();
      return result;
    } on FirebaseAuthException catch(e) {
      return e;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return _auth.signOut();
    } on FirebaseAuthException catch(e) {
      return e;
    }
  }
}
