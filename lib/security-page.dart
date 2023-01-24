import 'dart:async';

import 'package:flutter/material.dart';
import 'change-email.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _visible = false;
  bool _animated = false;

  void animate() {
    Timer my_timer = Timer(Duration(milliseconds: 100), () {
      setState(() {
        print('worked');
        _visible = true;
        _animated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      animate();
    }

    final email_option = GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChangeEmail()));
      },
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: AnimatedAlign(
          curve: Curves.fastOutSlowIn,
          alignment: _animated ? Alignment.center : Alignment.centerRight,
          duration: Duration(milliseconds: 500),
          child: Container(
            width: 320,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.deepOrangeAccent, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(40),
                color: Colors.white),
            child: Row(
              children: [
                Icon(Icons.email_outlined),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Change E-mail Address',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
    );

    final pass_option = AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 700),
      child: AnimatedAlign(
        curve: Curves.fastOutSlowIn,
        alignment: _animated ? Alignment.center : Alignment.centerRight,
        duration: Duration(milliseconds: 700),
        child: Container(
          width: 320,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.deepOrangeAccent, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(40),
              color: Colors.white),
          child: Row(
            children: [
              Icon(Icons.key_outlined),
              SizedBox(
                width: 20,
              ),
              Text(
                'Change Password',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
    final dismiss_button = Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 17),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.fromLTRB(22, 12, 22, 12),
                backgroundColor: Colors.deepOrangeAccent),
            child: Text('Dismiss', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context)));

    final continue_button = Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 17),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.fromLTRB(22, 12, 22, 12),
                backgroundColor: Colors.red),
            child: Text('Continue', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context)));

    final delete_option = GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 200, 0, 280),
                child: AlertDialog(
                    title: Text(
                      'Are you sure that you want to delete yout account?',
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'This action is irreversible is',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 12),
                        ),
                        continue_button,
                        dismiss_button,
                      ],
                    )),
              );
            });
      },
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 900),
        child: AnimatedAlign(
          curve: Curves.fastOutSlowIn,
          alignment: _animated ? Alignment.center : Alignment.centerRight,
          duration: Duration(milliseconds: 900),
          child: Container(
            width: 320,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.deepOrangeAccent, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(40),
                color: Colors.red),
            child: Row(
              children: [
                Icon(Icons.dangerous),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
          ),
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
              padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Return', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    final title = Text(
      'Security Settings',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 40),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title,
              SizedBox(
                height: 70,
              ),
              email_option,
              SizedBox(
                height: 10,
              ),
              pass_option,
              SizedBox(
                height: 10,
              ),
              delete_option,
              SizedBox(
                height: 60,
              ),
              return_button
            ],
          ),
        ),
      ),
    );
  }
}
