import 'dart:ffi';
import 'package:aft_arabia/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
export 'services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
export 'services/database.dart';
import 'services/auth.dart' show AuthService;

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
  bool _visible = false;
  bool _hidden = true;
  IconData pass_ind = Icons.remove_red_eye_outlined;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    final title = Text(
      'Change Email',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 40),
    );

    final email_label = Text(
      '    Your Account E-mail:',
      style: TextStyle(color: Colors.black54),
    );
    final pass_lable = Text(
      '    Password:',
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

    final pass = TextFormField(
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
      controller: pass_controller,
      keyboardType: TextInputType.name,
      autofocus: false,
      obscureText: _hidden,
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
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              final res = await _email_changer.changeEmail(
                  email_controller.text.trim(),
                  pass_controller.text,
                  new_email_controller.text);
              if (res == true) {
                print('succeeded');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Verification Email Sent!',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.teal,
                  ),
                );
                setState(() {
                  _visible = true;
                });
              } else if (res == 1) {
                print('failed');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Authentication Error: Check E-mail and password',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                print(res);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Unknown Error',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
            ;
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

    final hint_text = Visibility(
      visible: _visible,
      child: Text(
        'A verification E-mail has been sent to the new address that you have provided.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blueGrey, fontSize: 12),
      ),
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
                  height: 20,
                ),
                pass_lable,
                pass,
                Row(children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (pass_ind == Icons.remove_red_eye_outlined) {
                          pass_ind = Icons.remove_red_eye_sharp;
                        } else {
                          pass_ind = Icons.remove_red_eye_outlined;
                        }
                        _hidden = !_hidden;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Icon(pass_ind),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(215, 0, 0, 0),
                    child: Text(
                      'Clear all',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        email_controller.text = '';
                        new_email_controller.text = '';
                        verify_new_email_controller.text = '';
                        pass_controller.text = '';
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Icon(Icons.delete_forever_sharp),
                    ),
                  )
                ]),
                SizedBox(
                  height: 60,
                ),
                submit,
                return_button,
                SizedBox(
                  height: 30,
                ),
                hint_text
              ],
            ),
          ),
        ),
      ),
    );
  }
}
