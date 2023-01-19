import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  static String tag = 'home-page';
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[200],
          title: Text('this is the home page'),
          elevation: 0.0),
      body: Center(
        child: ElevatedButton(
          child: Text('sign out'),
          onPressed: () async {
            await _auth.signOut();
          },
        ),
      ),
    );
  }
}
