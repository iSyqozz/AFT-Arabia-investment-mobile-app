import 'dart:convert';
import 'dart:async';
import 'package:aft_arabia/main.dart';

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
  String pfp_url = '';
  String display_second_name = '---';
  String? curr_user_id = '---';
  String number = '---';
  String user_theme = '---';

  ImageProvider profile_pic =
      Image.asset('lib/images/pfp-placeholder.jpg').image;
  Color screen_mode = Color.fromARGB(66, 78, 74, 74);
  Map<Color, Color> screen_mode_map = {
    Colors.white: Colors.black,
    Color.fromARGB(66, 78, 74, 74): Colors.white,
  };

  Map<String, List<Color>> theme_map = {
    'orange': [Colors.deepOrangeAccent, Colors.deepOrange],
    'purple': [Color.fromARGB(255, 40, 21, 92), Color.fromARGB(255, 29, 7, 66)],
    'teal': [Colors.teal, Color.fromARGB(255, 1, 92, 83)],
  };

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

  void change_screen_mode() {
    setState(() {
      if (screen_mode == Colors.white) {
        screen_mode = Color.fromARGB(66, 78, 74, 74);
      } else {
        screen_mode = Colors.white;
      }
    });
  }

  void set_display_name(String? uid) async {
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
          profile_pic = temp['Profile Photo'] == ''
              ? Image.asset(
                  'lib/images/pfp-placeholder.jpg',
                  fit: BoxFit.contain,
                ).image
              : Image.network(temp['Profile Photo']).image;
          pfp_url = temp['Profile Photo'];
          user_theme = temp['user theme'];
          MaterialColor new_theme;

          if (user_theme == 'orange') {
            new_theme = Colors.deepOrange;
          } else if (user_theme == 'teal')
            new_theme = Colors.teal;
          else {
            new_theme = Colors.deepPurple;
          }
          MyApp.of(context)?.changeTheme(new_theme);
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
      style: TextStyle(color: screen_mode_map[screen_mode], fontSize: 12),
    );
    final bug_label2 = Text(
      ' of the Bug/Issue that you have encountered.',
      style: TextStyle(color: screen_mode_map[screen_mode], fontSize: 12),
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
      style: TextStyle(fontSize: 12, color: screen_mode_map[screen_mode]),
      decoration: InputDecoration(
        hintText: '...',
        contentPadding: EdgeInsets.fromLTRB(22.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide:
                BorderSide(color: screen_mode_map[screen_mode] as Color)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
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
                backgroundColor: theme_map[user_theme]?[0]),
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
                backgroundColor: theme_map[user_theme]?[0]),
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
            backgroundColor: screen_mode,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            insetPadding: EdgeInsets.fromLTRB(55, 50, 55, 50),
            title: Text(
              'Report a Bug',
              style: TextStyle(color: screen_mode_map[screen_mode]),
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
            color: theme_map[user_theme]?[1], // button color
            child: InkWell(
              splashColor: theme_map[user_theme]?[0], // splash color
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
      backgroundColor: theme_map[user_theme]?[0],
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
                    backgroundColor: theme_map[user_theme]?[1]),
                child: Text('Account',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                onPressed: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Transition()));
                  List<dynamic> new_info = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return ProfilePage(
                          number: number,
                          name1: display_name,
                          name2: display_second_name,
                          current_uid: user?.uid as String,
                          home_file_path: profile_pic,
                          screen_mode: screen_mode,
                          pfp_url: pfp_url,
                        );
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  setState(() {
                    display_name = new_info[0];
                    display_second_name = new_info[1];
                    number = new_info[2];
                    profile_pic = new_info[3];
                    pfp_url = new_info[4];
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
                    backgroundColor: theme_map[user_theme]?[1]),
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
                        return SecurityPage(
                          screen_mode: screen_mode,
                          user_theme: user_theme,
                        );
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
                    backgroundColor: theme_map[user_theme]?[1]),
                child: Text('About Us',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                onPressed: () {}),
          ),
        ),
      ),
    );

    final Widget investor_bank_button = Visibility(
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
                    backgroundColor: theme_map[user_theme]?[1]),
                child: Text('AFT Bank',
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
                    backgroundColor: theme_map[user_theme]?[1]),
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
                        return ContactPage(
                          screen_mode: screen_mode,
                          user_theme: user_theme,
                        );
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
              color: theme_map[user_theme]?[0],
              width: _side_menu_width,
              child: ListView(
                children: <Widget>[
                  account_button,
                  investor_bank_button,
                  security_button,
                  about_us,
                  contact_us_button,
                  SizedBox(
                    height: 380,
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
          backgroundColor: screen_mode,
          floatingActionButton: report_bug,
          appBar: AppBar(
            toolbarHeight: 45,
            backgroundColor: theme_map[user_theme]?[0],
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
                  List<dynamic> new_info = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return ProfilePage(
                          number: number,
                          name1: display_name,
                          name2: display_second_name,
                          current_uid: user?.uid as String,
                          home_file_path: profile_pic,
                          screen_mode: screen_mode,
                          pfp_url: pfp_url,
                        );
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  setState(() {
                    display_name = new_info[0];
                    display_second_name = new_info[1];
                    number = new_info[2];
                    profile_pic = new_info[3];
                    pfp_url = new_info[4];
                  });
                },
                child: CircleAvatar(radius: 16, backgroundImage: profile_pic),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          body: Stack(
            children: <Widget>[
              background_logo,
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: change_screen_mode,
                      icon: Icon(
                        screen_mode == Colors.white
                            ? Icons.mode_night_outlined
                            : Icons.wb_sunny_outlined,
                        size: 30,
                        color: screen_mode == Colors.white
                            ? Colors.blueGrey
                            : Colors.white,
                      ))),
              side_menu,
            ],
          )),
    );
  }
}
