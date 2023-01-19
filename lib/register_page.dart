import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  final AuthService _register_checker = AuthService();
  final _formkey = GlobalKey<FormState>();
  final first_name_controller = TextEditingController();
  final second_name_controller = TextEditingController();
  final number_controller = TextEditingController();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final confirm_password_controller = TextEditingController();
  String in_use = '';

  Widget build(BuildContext context) {
    //name lable and field
    final in_use_prompt = Center(
      child: Text(
        in_use,
        style: TextStyle(color: Colors.red, fontSize: 15.0),
      ),
    );

    final name_label = Text(
      '    First Name:',
      style: TextStyle(color: Colors.black54),
    );

    final name = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 20) {
          return "This Field Can't Have more than 20 characters";
        } else {
          return null;
        }
      },
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
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 20) {
          return "This Field Can't Have more than 20 characters";
        } else {
          return null;
        }
      },
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
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 20) {
          return "This Field Can't Have more than 20 Numbers";
        } else {
          return null;
        }
      },
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
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val!)) {
          return 'Please Enter Valid Email Address';
          ;
        } else if (val.length > 320) {
          return "This Field Can't Have more than 20 characters";
        } else {
          return null;
        }
      },
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
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 100) {
          return "This Field Can't Have more than 100 characters";
        } else if (val.length < 8) {
          return "Password Can't Have less than 8 Characters";
        } else if ((!RegExp('(?=.*[A-Z])').hasMatch(val))) {
          return "Password Must Have One Uppercase Letter";
        } else if ((!RegExp('(?=.*[0-9])').hasMatch(val))) {
          return "Password Must Have One Digit";
        } else if ((RegExp('(?=.*[\(\)-+_!@#\$%^&*.,? \n/\"\'\:\;])')
            .hasMatch(val))) {
          return "Password Can't Contain Special Characters";
        } else {
          return null;
        }
      },
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
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val != password_controller.text) {
          return "Input Doesn't match Password";
        } else {
          return null;
        }
      },
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
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              dynamic res = await _register_checker.SignUp(
                  first_name_controller.text,
                  second_name_controller.text,
                  number_controller.text,
                  email_controller.text,
                  password_controller.text);
              if (res == null) {
                setState(() {
                  in_use = 'Check Internet Connection';
                });
              } else if (res == 1) {
                setState(() {
                  in_use = 'Email is already registered';
                });
              } else {
                Navigator.pop(context);
                print(res.uid);
              }
            }
          }),
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
            child: Form(
                key: _formkey,
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
                    SizedBox(height: 20.0),
                    registerButton,
                    return_button,
                    SizedBox(
                      height: 5.0,
                    ),
                    in_use_prompt
                  ],
                )),
          ),
        ));
  }
}
