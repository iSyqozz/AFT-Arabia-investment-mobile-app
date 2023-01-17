import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

//This is where the program and application starts
void main() => runApp(MyApp());

//class for the main app
class MyApp extends StatelessWidget {
  //creating routes for user navigation
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    RegisterPage.tag: (context) => RegisterPage(),
  };

  //main build method for the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Nunito',
      ),

      //start at the login page
      home: LoginPage(),
      routes: routes,
    );
  }
}
