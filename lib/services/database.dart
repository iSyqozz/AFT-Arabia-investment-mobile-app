import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference user_collection =
      FirebaseFirestore.instance.collection('User Data');

  DocumentReference fetch_data(String? uid) {
    return user_collection.doc(uid);
  }

  Future update_user_data(
    String name,
    String second_name,
    String number,
    String email,
  ) async {
    try {
      return await user_collection.doc(uid).set({
        'name': name,
        'second name': second_name,
        'number': number,
        'email': email,
      });
    } catch (e) {
      print(e.toString());
    }
    ;
  }
}