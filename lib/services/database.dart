import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference user_collection =
      FirebaseFirestore.instance.collection('User Data');

  DocumentReference fetch_data(String? uid) {
    var temp = user_collection.doc(uid);
    //print(temp);
    return temp;
  }

  Future<bool> update_profile_photo(String name, String second_name,
      String number, String path, String theme) async {
    try {
      final res = await user_collection.doc(uid).set({
        'name': name,
        'second name': second_name,
        'number': number,
        'Profile Photo': path,
        'user theme': theme
      });
      return true;
    } catch (e) {
      //print(e.toString());
      return false;
    }
  }

  Future update_user_data(String name, String second_name, String number,
      String profile_photo_link, String theme) async {
    try {
      final res = await user_collection.doc(uid).set({
        'name': name,
        'second name': second_name,
        'number': number,
        'Profile Photo': profile_photo_link,
        'user theme': theme
      });
      return true;
    } catch (e) {
      //print(e.toString());
      return null;
    }
    ;
  }
}
