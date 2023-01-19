import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final first_name_controller = TextEditingController();
    final second_name_controller = TextEditingController();
    final number_controller = TextEditingController();
    final email_controller = TextEditingController();
    final password_controller = TextEditingController();
    final confirm_password_controller = TextEditingController();
    final AuthService _register_checker = AuthService();

    //name lable and field
    final name_label = Text(
      '    First Name:',
      style: TextStyle(color: Colors.black54),
    );

    final name = TextFormField(
      controller: first_name_controller,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Joe',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //second name lable and field
    final second_name_label = Text(
      '    Second Name:',
      style: TextStyle(color: Colors.black54),
    );

    final second_name = TextFormField(
      controller: second_name_controller,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Smith',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //number lable and field
    final number_label = Text(
      '    Number:',
      style: TextStyle(color: Colors.black54),
    );

    final number = TextFormField(
      controller: number_controller,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'xxx-xxxxxxx',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //email lable and field
    final email_label = Text(
      '    E-mail:',
      style: TextStyle(color: Colors.black54),
    );

    final email = TextFormField(
      controller: email_controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'example@abc.com',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //number lable and field
    final password_label = Text(
      '    Password:',
      style: TextStyle(color: Colors.black54),
    );
    final password = TextFormField(
      controller: password_controller,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //number lable and field
    final confirm_password_lable = Text(
      '    Confirm Password:',
      style: TextStyle(color: Colors.black54),
    );

    final confirm_password = TextFormField(
      controller: confirm_password_controller,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //Register Button Widget
    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Finish Registeration',
              style: TextStyle(color: Colors.white)),
          onPressed: () {}),
    );

    final return_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Return', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    // creating main scaffold container, putting everything together, and returning the the page
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ListView(
              shrinkWrap: false,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: 80.0),
                name_label,
                name,
                SizedBox(height: 15.0),
                second_name_label,
                second_name,
                SizedBox(height: 15.0),
                number_label,
                number,
                SizedBox(height: 15.0),
                email_label,
                email,
                SizedBox(height: 15.0),
                password_label,
                password,
                SizedBox(height: 15.0),
                confirm_password_lable,
                confirm_password,
                SizedBox(height: 40.0),
                registerButton,
                return_button,
              ],
            ),
          ),
        ));
  }
}
