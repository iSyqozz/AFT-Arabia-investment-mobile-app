import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'contact_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static String tag = 'home-page';
  final AuthService _auth = AuthService();
  bool _visible = false;
  double _side_menu_width = 0.0;
  bool _side_menu_buttons_visible = false;
  final _bug_form_controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String snackbar_content = 'Bug Form Submitted Succesfully!';
  MaterialColor snackbar_col = Colors.teal;
  bool _is_transition = true;

  final Transition = Container(
      child: SpinKitCubeGrid(
    color: Colors.deepOrangeAccent,
  ));

  Timer scheduleTimeout([int milliseconds = 2000, String name = 'sign in']) =>
      Timer(Duration(milliseconds: milliseconds), () {
        setState(() {
          if (name == 'Transition Contact') {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ContactPage()));
          }
        });

        sleep(Duration(milliseconds: 20));

        setState(() {
          _is_transition = false;
        });
      });

  late final AnimationController icon_controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  void dispose() {
    super.dispose();
    icon_controller.dispose();
  }

  void show_menu() {
    setState(() {
      if (_side_menu_buttons_visible) {
        _side_menu_buttons_visible = false;
      }
      if (_side_menu_width == 130) {
        icon_controller.reverse();
        _side_menu_width = 0;
      } else {
        icon_controller.forward();
        _side_menu_width = 130;
      }
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_is_transition) {
      scheduleTimeout(2000);
    }

    final succes_prompt = SnackBar(
      content: Text(
        snackbar_content,
        textAlign: TextAlign.center,
      ),
      backgroundColor: snackbar_col,
    );

    final bug_label = Text(
      'Please provide a well-explained description',
      style: TextStyle(color: Colors.black54, fontSize: 12),
    );
    final bug_label2 = Text(
      ' of the Bug/Issue that you have encountered.',
      style: TextStyle(color: Colors.black54, fontSize: 12),
    );

    final bug_form = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 500) {
          return "This Field Can't Have more than 500 characters";
        } else {
          return null;
        }
      },
      controller: _bug_form_controller,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      autofocus: false,
      style: TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: '...',
        contentPadding: EdgeInsets.fromLTRB(22.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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

    final submit_button = Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.fromLTRB(25, 12, 25, 12),
                backgroundColor: Colors.teal),
            child: Text('Submit', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                final response =
                    await http.post(Uri.parse('http://192.168.1.43:5000/email'),
                        body: json.encode(<String, dynamic>{
                          'subject': 'Bug Report',
                          'email': 'Anon App User',
                          'body': _bug_form_controller.text
                        }));
                print(response.statusCode);
                if (response.statusCode == 200) {
                  setState(() {
                    snackbar_content = 'Bug Form Submitted Succesfully!';
                    snackbar_col = Colors.teal;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(succes_prompt);
                  Future.delayed(Duration(seconds: 3));
                  Navigator.pop(context);
                } else {
                  print('failed with $response.statuscode');
                  setState(() {
                    snackbar_content = 'Bug Form Submission Failed';
                    snackbar_col = Colors.red;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(succes_prompt);
                }
              }
            }));

    //alert popup for submitting bug
    final report_bug_alert = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            insetPadding: EdgeInsets.fromLTRB(55, 50, 55, 50),
            title: Text(
              'Report a Bug',
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: _formkey,
              child: Column(children: [
                bug_label,
                SizedBox(
                  height: 3,
                ),
                bug_label2,
                SizedBox(
                  height: 20,
                ),
                bug_form,
                Row(
                  children: [
                    dismiss_button,
                    submit_button,
                  ],
                )
              ]),
            )),
      ),
    );

    //bug reporting button
    final report_bug = SingleChildScrollView(
        child: FloatingActionButton(
      heroTag: null,
      child: SizedBox.fromSize(
        size: Size(56, 56), // button width and height
        child: ClipOval(
          child: Material(
            color: Colors.deepOrange, // button color
            child: InkWell(
              splashColor: Colors.deepOrangeAccent, // splash color
              onTap: () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return report_bug_alert;
                    })).then((value) {
                  setState(() {
                    _bug_form_controller.text = '';
                  });
                });
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Report a Bug",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ), // text
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.deepOrangeAccent,
      foregroundColor: Colors.white,
      onPressed: () {},
    ));

    //sign out button
    final Widget sign_out_button = Visibility(
      visible: _side_menu_buttons_visible,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.fromLTRB(30, 12, 30, 10),
                    backgroundColor: Colors.red),
                child: Text('Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                onPressed: () async {
                  dispose();
                  await _auth.signOut();
                }),
          ),
        ),
      ),
    );

    //settings Button
    final Widget settings_button = Visibility(
      visible: _side_menu_buttons_visible,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.fromLTRB(30, 12, 30, 10),
                    backgroundColor: Colors.deepOrange),
                child: Text('Settings',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                onPressed: () {}),
          ),
        ),
      ),
    );

    final Widget contact_us_button = Visibility(
      visible: _side_menu_buttons_visible,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.fromLTRB(25, 13, 25, 11),
                    backgroundColor: Colors.deepOrange),
                child: Text('Contact Us',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                onPressed: () {
                  setState(() {
                    _is_transition = true;
                  });
                  scheduleTimeout(2000, 'Transition Contact');
                }),
          ),
        ),
      ),
    );

    final menu_button = GestureDetector(
        onTap: () {
          show_menu();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 0, 0),
          child: AnimatedIcon(
            size: 30,
            icon: AnimatedIcons.menu_arrow,
            progress: icon_controller,
          ),
        ));

    final side_menu = AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      onEnd: () {
        setState(() {
          _side_menu_buttons_visible = true;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx < 0 && _visible) {
                show_menu();
              }
            },
            child: AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 500),
              color: Colors.deepOrangeAccent,
              width: _side_menu_width,
              child: ListView(
                children: <Widget>[
                  settings_button,
                  contact_us_button,
                  SizedBox(
                    height: 540,
                  ),
                  sign_out_button,
                ],
              ),
            ),
          ))
        ],
      ),
    );

    final background_logo = Center(
      child: Opacity(
        opacity: 0.07,
        child: Image.asset(
          'lib/images/logo.png',
          height: 600,
          width: 600,
          fit: BoxFit.cover,
        ),
      ),
    );

    return _is_transition
        ? Transition
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scaffold(
                floatingActionButton: report_bug,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.deepOrangeAccent,
                  leading: menu_button,
                ),
                body: Stack(
                  children: <Widget>[
                    background_logo,
                    side_menu,
                    report_bug,
                  ],
                )),
          );
  }
}
