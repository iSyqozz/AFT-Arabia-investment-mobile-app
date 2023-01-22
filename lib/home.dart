import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'contact_page.dart';

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

  @override
  Widget build(BuildContext context) {
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
      decoration: InputDecoration(
        hintText: '...',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final dismiss_button = Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 18),
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
            onPressed: () => Navigator.pop(context)));

    final report_bug_alert = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            insetPadding: EdgeInsets.fromLTRB(0, 100, 0, 250),
            title: Text(
              'Report a Bug',
              textAlign: TextAlign.center,
            ),
            content: Form(
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
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ContactPage()));
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
                  sign_out_button,
                ],
              ),
            ),
          ))
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          floatingActionButton: report_bug,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            elevation: 0.0,
            leading: menu_button,
          ),
          body: Stack(
            children: <Widget>[
              side_menu,
              report_bug,
            ],
          )),
    );
  }
}
