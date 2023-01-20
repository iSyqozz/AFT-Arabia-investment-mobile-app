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

  Future signIn(String email, String pwd) async {
    try {
      var result =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      var user = result.user;
      return _get_user_id(user);
    } catch (e) {
      print(e.toString());
      if (e.toString() == '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.' ||
          e.toString() ==
              '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.' ||
          e.toString() ==
              '[firebase_auth/invalid-email] The email address is badly formatted.') {
        return 1;
      } else {
        return null;
      }
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
  Future SignUp(String name, String second_name, String number, String email,
      String pwd) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      var user = result.user;
      return _get_user_id(user);
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        return 1;
      } else {
        return null;
      }
    }
  }
}
