import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactPage extends StatefulWidget {
  Color screen_mode;
  String user_theme;
  ContactPage({super.key, required this.screen_mode, required this.user_theme});

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
  Map<Color, Color> screen_mode_map = {
    Colors.white: Colors.black,
    Color.fromARGB(66, 78, 74, 74): Colors.white,
  };
  Map<String, List<Color>> theme_map = {
    'orange': [Colors.deepOrangeAccent, Colors.deepOrange],
    'purple': [Color.fromARGB(255, 40, 21, 92), Color.fromARGB(255, 29, 7, 66)],
    'teal': [Colors.teal, Color.fromARGB(255, 1, 92, 83)],
  };

  @override
  Widget build(BuildContext context) {
    final subject_label = Text(
      '    Subject:',
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
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
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
      decoration: InputDecoration(
        hintText: widget.screen_mode == Colors.white ? 'Inquiry' : '',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
                color: screen_mode_map[widget.screen_mode] as Color)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final title = Text(
      'Contact Us',
      textAlign: TextAlign.center,
      style:
          TextStyle(fontSize: 40, color: screen_mode_map[widget.screen_mode]),
    );

    final email_label = Text(
      '    E-mail:',
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
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
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'example@abc.com',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
                color: screen_mode_map[widget.screen_mode] as Color)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final body_label = Text(
      '    Content:',
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
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
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '...',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
                color: screen_mode_map[widget.screen_mode] as Color)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
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
              backgroundColor: theme_map[widget.user_theme]?[0]),
          child: Text('Return', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    final submit_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: theme_map[widget.user_theme]?[0]),
          child: Text('Submit', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              try {
                final response =
                    await http.post(Uri.parse('http://192.168.1.43:5000/email'),
                        body: json.encode({
                          'subject': _subject_controller.text,
                          'email': _email_controller.text,
                          'body': _body_controller.text,
                        }));
                print(response.statusCode);
                if (response.statusCode == 200) {
                  int tri_flag = 1;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        tri_flag == 1
                            ? 'Form Submitted Succesfully!'
                            : 'Form Submission Failed',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: tri_flag == 1 ? Colors.teal : Colors.red,
                    ),
                  );
                } else {
                  int tri_flag = 2;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        tri_flag == 1
                            ? 'Form Submitted Succesfully!'
                            : 'Form Submission Failed',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: tri_flag == 1 ? Colors.teal : Colors.red,
                    ),
                  );
                }
                int tri_flag = 2;
              } catch (e) {
                int tri_flag = 2;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      tri_flag == 1
                          ? 'Form Submitted Succesfully!'
                          : 'Form Submission Failed',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: tri_flag == 1 ? Colors.teal : Colors.red,
                  ),
                );
              }
            }
          }),
    );

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: widget.screen_mode,
          body: Center(
            child: Form(
              key: _formkey,
              child: ListView(
                shrinkWrap: false,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: [
                  SizedBox(height: 80.0),
                  title,
                  SizedBox(
                    height: 50,
                  ),
                  subject_label,
                  subject,
                  SizedBox(height: 20.0),
                  email_label,
                  email,
                  SizedBox(height: 40.0),
                  body_label,
                  SizedBox(height: 5.0),
                  body,
                  SizedBox(height: 30.0),
                  submit_button,
                  return_button,
                ],
              ),
            ),
          ),
        ));
  }
}
