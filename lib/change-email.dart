import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:aft_arabia/services/auth.dart';
import 'services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final AuthService _email_changer = AuthService();
  final email_controller = TextEditingController();
  final new_email_controller = TextEditingController();
  final verify_new_email_controller = TextEditingController();
  final pass_controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Change Email',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 40),
    );

    final email_label = Text(
      '    Your Account E-mail:',
      style: TextStyle(color: Colors.black54),
    );
    final new_email_label = Text(
      '    New E-mail:',
      style: TextStyle(color: Colors.black54),
    );
    final confirm_new_email_label = Text(
      '    Confirm new E-mail:',
      style: TextStyle(color: Colors.black54),
    );

    final email = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val!)) {
          return 'Please Enter a Valid Email Address';
          ;
        } else if (val.length > 320) {
          return "This Field Can't Have more than 320 characters";
        } else if (FirebaseAuth.instance.currentUser!.email !=
            email_controller.text) {
          return "Input Doesn't match your account's E-mail!!";
        } else {
          return null;
        }
      },
      controller: email_controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final new_email = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val!)) {
          return 'Please Enter a Valid Email Address';
          ;
        } else if (val.length > 320) {
          return "This Field Can't Have more than 320 characters";
        } else {
          return null;
        }
      },
      controller: new_email_controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final new_confirm_email = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val!)) {
          return 'Please Enter a Valid Email Address';
          ;
        } else if (val.length > 320) {
          return "This Field Can't Have more than 320 characters";
        } else if (verify_new_email_controller.text !=
            new_email_controller.text) {
          return "Input Doesn't match you new E-mail";
        } else {
          return null;
        }
      },
      controller: verify_new_email_controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final submit = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
              backgroundColor: Colors.deepOrangeAccent),
          child:
              Text('Verify & Proceed', style: TextStyle(color: Colors.white)),
          onPressed: () {
            _formkey.currentState?.validate();
          }),
    );

    final return_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Return', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

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
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              shrinkWrap: false,
              children: [
                SizedBox(height: 100),
                title,
                SizedBox(
                  height: 30,
                ),
                email_label,
                email,
                SizedBox(
                  height: 20,
                ),
                new_email_label,
                new_email,
                SizedBox(
                  height: 20,
                ),
                confirm_new_email_label,
                new_confirm_email,
                SizedBox(
                  height: 60,
                ),
                submit,
                return_button,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
