import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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

  late final AnimationController icon_controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  void dispose() {
    icon_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: Colors.deepOrange),
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
                onPressed: () {}),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            elevation: 0.0,
            leading: GestureDetector(
                onTap: () {
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
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 12, 0, 0),
                  child: AnimatedIcon(
                    size: 30,
                    icon: AnimatedIcons.menu_arrow,
                    progress: icon_controller,
                  ),
                )),
          ),
          body: Stack(
            children: <Widget>[
              AnimatedOpacity(
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
                        child: AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(milliseconds: 500),
                      color: Colors.deepOrangeAccent,
                      width: _side_menu_width,
                      child: ListView(
                        children: <Widget>[
                          settings_button,
                          contact_us_button,
                          sign_out_button,
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
