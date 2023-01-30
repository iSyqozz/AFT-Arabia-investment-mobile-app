import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aft_arabia/services/auth.dart';
import 'services/auth.dart';
import 'utils/transition.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final auth_inter = AuthService();
  final auth = FirebaseAuth.instance;
  var curr_user;
  late Timer timer;

  @override
  void initState() {
    var curr_user = auth.currentUser;
    curr_user?.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkverfied();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkverfied() async {
    curr_user = auth.currentUser;
    await curr_user.reload();
    if (curr_user.emailVerified) {
      timer.cancel();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Verify Your Account',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 37),
    );

    final details = Text(
      textAlign: TextAlign.center,
      "Check your Inbox for a verification E-mail.\nIf you can't find the Email, look for it in your spam folder.\n Alternatively you can request another verfication link by\nclicking the re-send verification link button",
      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
    );

    final sign_out_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 120),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: Colors.red),
          child: Text('Sign Out',
              style: TextStyle(color: Colors.white, fontSize: 13)),
          onPressed: () async {
            await auth_inter.signOut();
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Transition(
                      user_theme: 'orange',
                    )));
            timer.cancel();
            Navigator.pop(context);
          }),
    );

    final resend_email_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 120),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: Colors.deepOrange),
          child: Text('Resend Email',
              style: TextStyle(color: Colors.white, fontSize: 13)),
          onPressed: () async {
            try {
              var res = await curr_user?.sendEmailVerification();
              print('res');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Email sent!',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.teal,
              ));
            } catch (e) {
              print(e.toString());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Failed to send Emai, Try again later. ',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
              ));
            }
          }),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            shrinkWrap: false,
            children: [
              SizedBox(
                height: 200,
              ),
              title,
              SizedBox(
                height: 20,
              ),
              details,
              SizedBox(
                height: 30,
              ),
              resend_email_button,
              sign_out_button
            ],
          )),
    );
  }
}
