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
}

class _MyAppState extends State<MyApp> {
  //creating routes for user navigation
  final routes = <String, WidgetBuilder>{
    RegisterPage.tag: (context) => RegisterPage(),
  };

  final _scaffold_key = GlobalKey<ScaffoldMessengerState>();
  var _user_theme = Colors.white;
  void changeTheme(var theme) {
    setState(() {
      _user_theme = theme;
    });
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    ;
    return MaterialColor(color.value, swatch);
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
          primarySwatch: createMaterialColor(Colors.blueGrey),
          primaryColor: _user_theme,
          fontFamily: 'Nunito',
        ),

        //start at the login page or home page
        home: Wrapper(),
        routes: routes,
      ),
    );
  }
}
