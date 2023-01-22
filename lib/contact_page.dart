import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactPage extends StatefulWidget {
  static String tag = 'contact-page';
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formkey = GlobalKey<FormState>();
  final _subject_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _body_controller = TextEditingController();
  String snackbar_content = 'Form Submitted Succesfully!';
  MaterialColor snackbar_col = Colors.teal;

  @override
  Widget build(BuildContext context) {
    final subject_label = Text(
      '    Subject:',
      style: TextStyle(color: Colors.black54),
    );

    final subject = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 50) {
          return "This Field Can't Have more than 50 characters";
        } else {
          return null;
        }
      },
      controller: _subject_controller,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Inquiry',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

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
          return 'Please Enter a Valid Email Address';
          ;
        } else if (val.length > 320) {
          return "This Field Can't Have more than 320 characters";
        } else {
          return null;
        }
      },
      controller: _email_controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'example@abc.com',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final body_label = Text(
      '    Content:',
      style: TextStyle(color: Colors.black54),
    );

    final body = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 500) {
          return "This Field Can't Have more than 500 characters";
        } else {
          return null;
        }
      },
      controller: _body_controller,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '...',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
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

    final succes_prompt = SnackBar(
      content: Text(
        snackbar_content,
        textAlign: TextAlign.center,
      ),
      backgroundColor: snackbar_col,
    );

    final submit_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Submit', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              final response =
                  await http.post(Uri.parse('http://192.168.1.43:5000/email'),
                      body: json.encode({
                        'subject': _subject_controller.text,
                        'email': _email_controller.text,
                        'body': _body_controller.text,
                      }));
              print(response.statusCode);
              if (response.statusCode == 200) {
                setState(() {
                  snackbar_content = 'Form Submitted Succesfully!';
                  snackbar_col = Colors.teal;
                });
                ScaffoldMessenger.of(context).showSnackBar(succes_prompt);
              } else {
                print('failed with $response.statuscode');
                setState(() {
                  snackbar_content = 'Form Submission Failed';
                  snackbar_col = Colors.red;
                });
                ScaffoldMessenger.of(context).showSnackBar(succes_prompt);
              }
            }
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
                shrinkWrap: false,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: [
                  SizedBox(height: 80.0),
                  subject_label,
                  subject,
                  SizedBox(height: 20.0),
                  email_label,
                  email,
                  SizedBox(height: 40.0),
                  body_label,
                  SizedBox(height: 5.0),
                  body,
                  SizedBox(height: 40.0),
                  submit_button,
                  return_button,
                ],
              ),
            ),
          ),
        ));
  }
}
