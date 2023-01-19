import 'package:firebase_auth/firebase_auth.dart';

//custom usr class for acessing uid
class User {
  final String? uid;

  User({this.uid});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //auth change user stream

  Stream<User?> get user {
    return _auth.authStateChanges().map(_get_user_id);
  }

  //create user obj with uid only
  User? _get_user_id(user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // sign in method for email and password

  Future signInAnon() async {
    try {
      var result = await _auth.signInAnonymously();
      var user = result.user;
      return _get_user_id(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  //register with email and password

}
