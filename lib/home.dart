import 'dart:convert';
import 'dart:async';
import 'security-page.dart';
import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'contact_page.dart';
import 'services/database.dart';
import 'utils/transition.dart';
import 'profile_page.dart';

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

  String display_name = '---';
  String display_second_name = '---';
  String? curr_user_id = '---';
  String number = '---';

  void remove(AnimationController e) {
    e.dispose();
  }

  void show_menu(e) {
    setState(() {
      if (_side_menu_buttons_visible) {
        _side_menu_buttons_visible = false;
      }
      if (_side_menu_width == 130) {
        e.reverse();
        _side_menu_width = 0;
      } else {
        e.forward();
        _side_menu_width = 130;
      }
      _visible = !_visible;
    });
  }

  void set_display_name(String? uid) {
    print('setting name...');
    final temp = DatabaseService().fetch_data(uid);
    temp.get().then((value) {
      final temp = value.data() as Map<String, dynamic>;
      setState(() {
        try {
          display_name = temp['name'];
          display_second_name = temp['second name'];
          number = temp['number'];
          curr_user_id = uid;
        } catch (e) {
          print(e.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    late final AnimationController icon_controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final user = Provider.of<User?>(context);
    print(user);

    if (user != null && user.uid != curr_user_id) {
      set_display_name(user.uid);
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
    final sign_out_button = Visibility(
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
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Transition()));
                  remove(icon_controller);
                  await _auth.signOut();
                }),
          ),
        ),
      ),
    );

    //settings Button
    final Widget account_button = Visibility(
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
                child: Text('Account',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                onPressed: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Transition()));
                  List<String> new_info = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return ProfilePage(
                          number: number,
                          name1: display_name,
                          name2: display_second_name,
                        );
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  setState(() {
                    display_name = new_info[0];
                    display_second_name = new_info[1];
                    number = new_info[3];
                  });
                }),
          ),
        ),
      ),
    );

    final Widget security_button = Visibility(
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
                child: Text('Security',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                onPressed: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Transition()));
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return SecurityPage();
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }),
          ),
        ),
      ),
    );

    final Widget about_us = Visibility(
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
                child: Text('About Us',
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
                onPressed: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Transition()));
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return ContactPage();
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }),
          ),
        ),
      ),
    );

    final menu_button = GestureDetector(
        onTap: () {
          show_menu(icon_controller);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 7, 0, 0),
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
                show_menu(icon_controller);
              }
            },
            child: AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 500),
              color: Colors.deepOrangeAccent,
              width: _side_menu_width,
              child: ListView(
                children: <Widget>[
                  account_button,
                  security_button,
                  about_us,
                  contact_us_button,
                  SizedBox(
                    height: 435,
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: report_bug,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 45,
            backgroundColor: Colors.deepOrangeAccent,
            leading: menu_button,
            actions: [
              Row(children: [
                Text(
                  display_name,
                  style: TextStyle(
                      fontSize: (display_name + display_second_name).length > 26
                          ? 11
                          : 15,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  display_second_name,
                  style: TextStyle(
                      fontSize: (display_name + display_second_name).length > 20
                          ? 11
                          : 15,
                      color: Colors.white),
                ),
              ]),
              SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Transition()));
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return ProfilePage(
                          number: number,
                          name1: display_name,
                          name2: display_second_name,
                        );
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: Image.asset(
                    'lib/images/pfp-placeholder.jpg',
                    fit: BoxFit.contain,
                  ).image,
                ),
              ),
              SizedBox(
                width: 5,
              )
            ],
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
