import 'package:aft_arabia/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

//custom usr class for acessing uid
class User {
  final String? uid;

  User({this.uid});
}

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //auth change user stream

  Stream<User?> get user {
    return auth.authStateChanges().map(_get_user_id);
  }

  //create user obj with uid only
  User? _get_user_id(user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //ChangeEmail
  Future changeEmail(String email, String pass, String new_email) async {
    try {
      final res1 = await auth.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: pass));
    } catch (e) {
      //print(e.toString());
      return 1;
    }
    try {
      final user = auth.currentUser;
      final res = await user!.verifyBeforeUpdateEmail(new_email);
      return true;
    } catch (e) {
      //print(e.toString());
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        return 3;
      }
      return 2;
    }
  }

  // sign in method for email and password
  Future signIn(String email, String pwd) async {
    try {
      var result =
          await auth.signInWithEmailAndPassword(email: email, password: pwd);
      var user = result.user;
      //print(result);
      return user;
    } catch (e) {
      String error = e.toString();
      //print([
      //  '[firebaseauth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.',
      //  '[firebaseauth/wrong-password] The password is invalid or the user does not have a password.',
      //  '[firebaseauth/invalid-email] The email address is badly formatted.'
      //].contains(error));
      if (error.contains('formatted') ||
          error.contains('deleted') ||
          error.contains('invalid')) {
        return 1;
      } else {
        return null;
      }
    }
  }

  Future resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return 1;
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      //print(e.toString());
    }
  }

  //register with email and password
  Future SignUp(String name, String second_name, String number, String email,
      String pwd, String theme) async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      var user = result.user;
      await DatabaseService(uid: user?.uid)
          .update_user_data(name, second_name, number, '', theme);
      return _get_user_id(user);
    } catch (e) {
      //print(e.toString());
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        return 1;
      } else {
        return null;
      }
    }
  }
}
