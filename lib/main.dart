import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'register_page.dart';
import 'contact_page.dart';
import 'package:aft_arabia/wrapper.dart';
import 'package:aft_arabia/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//class for the main app
class MyApp extends StatelessWidget {
  //creating routes for user navigation
  final routes = <String, WidgetBuilder>{
    RegisterPage.tag: (context) => RegisterPage(),
  };

  final _scaffold_key = GlobalKey<ScaffoldMessengerState>();

  //main build method for the application
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        scaffoldMessengerKey: _scaffold_key,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Nunito',
        ),

        //start at the login page
        home: Wrapper(),
        routes: routes,
      ),
    );
  }
}
