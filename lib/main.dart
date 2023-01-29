import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'register_page.dart';
import 'package:aft_arabia/wrapper.dart';
import 'package:aft_arabia/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//class for the main app
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  //creating routes for user navigation
  final routes = <String, WidgetBuilder>{
    RegisterPage.tag: (context) => RegisterPage(),
  };

  final _scaffold_key = GlobalKey<ScaffoldMessengerState>();
  var _user_theme = Colors.deepOrange;
  void changeTheme(var theme) {
    setState(() {
      _user_theme = theme;
    });
  }

  //main build method for the application

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
          create: (context) => AuthService().user,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'AFT Arabia',
        scaffoldMessengerKey: _scaffold_key,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: _user_theme,
          fontFamily: 'Nunito',
        ),

        //start at the login page or home page
        home: Wrapper(),
        routes: routes,
      ),
    );
  }
}
