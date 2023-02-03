import 'dart:convert';
import 'dart:async';
import 'package:aft_arabia/main.dart';
import 'package:aft_arabia/shares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'security-page.dart';
import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'contact_page.dart';
import 'services/database.dart';
import 'utils/transition.dart';
import 'profile_page.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
  bool is_loaded = false;
  bool loading_ind_finish = false;
  bool home_initialized = false;
  bool big_loading_ind = true;

  String display_name = '---';
  String pfp_url = '';
  String display_second_name = '---';
  String? curr_user_id = '---';
  String number = '---';
  String user_theme = 'orange';
  int share_count = 0;
  double profit = 0;
  Iterable shares_data = Iterable.empty();
  int shares_val = 0;

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

  Future<void> set_details(String? uid, BuildContext context) async {
    //print('setting name...');
    final temp = await DatabaseService().fetch_data(uid);
    final data = await temp.get();
    final map = await data.data() as Map<String, dynamic>;
    QuerySnapshot user_shares = await FirebaseFirestore.instance
        .collection('User Data')
        .doc(uid as String)
        .collection('shares')
        .get();
    shares_data = user_shares.docs.map((doc) => doc.data());

    //getting share count and Profit
    for (var v in shares_data) {
      //print('one share');
      if (v['status'] == 'Active') {
        profit += (double.parse(v['currentprofit']));
        share_count += 1;
      }
    }
    shares_val = share_count * 50000;

    //print(share_count);
    setState(() {
      try {
        display_name = map['name'];
        display_second_name = map['second name'];
        number = map['number'];
        curr_user_id = uid;
        profile_pic = map['Profile Photo'] == ''
            ? Image.asset(
                'lib/images/pfp-placeholder.jpg',
                fit: BoxFit.contain,
              ).image
            : Image.network(map['Profile Photo']).image;
        pfp_url = map['Profile Photo'];
        user_theme = map['user theme'];
        home_initialized = true;
      } catch (e) {
        //print(e.toString());
      }
    });
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await set_details(curr_user_id, context);
      Timer mytimer = Timer(Duration(milliseconds: 2000), (() {
        setState(() {
          big_loading_ind = false;
        });
        Timer mytimer = Timer(Duration(milliseconds: 300), (() {
          setState(() {
            is_loaded = true;
          });
          Timer mytimer = Timer(Duration(milliseconds: 2500), (() {
            setState(() {
              loading_ind_finish = true;
            });
          }));
        }));
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    late final AnimationController icon_controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final user = Provider.of<User?>(context);
    //print(user);

    curr_user_id = user?.uid;

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
                try {
                  final response = await http.post(
                      Uri.parse(
                          'https://plankton-app-iiabn.ondigitalocean.app/email'),
                      body: json.encode(<String, dynamic>{
                        'subject': 'Bug Report',
                        'email': 'Anon App User',
                        'body': _bug_form_controller.text
                      }));
                  //print(response.statusCode);
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Submitted!',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.teal,
                    ));
                  } else {
                    //print('failed with $response.statuscode');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Failed!',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                } catch (e) {
                  //print(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Failed!',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.red,
                  ));
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
                    backgroundColor: Color.fromARGB(255, 129, 22, 15)),
                child: Text('Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Transition(
                            user_theme: user_theme,
                          )));
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
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Transition(
                            user_theme: user_theme,
                          )));
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
                          user_theme: user_theme,
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
                    user_theme = new_info[5];
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
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Transition(
                            user_theme: user_theme,
                          )));
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
                child: Text('Terms',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            backgroundColor: screen_mode,
                            title: Center(
                              child: Text(
                                'terms and conditions',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: screen_mode_map[screen_mode]),
                              ),
                            ),
                            content: Container(
                              height: 300,
                              width: 200,
                              child: ListView(children: [
                                Text(
                                  '1- An appointment is committed to depositing an amount of fifty thousand Algerian dinars (50,000 DZD) oranother country as a shareholding in the capitalQuantum Healing Fund\n2- Image rights are property rights independent\n3- The shareholder gets a profit of 6300 DZD (or what is equivalent to this percentage if he is from a country Others, according to the amount of each share in agreement with the Corporation) for each share he owns, and that is every 45 days Since the beginning of its detailed filing in a pre-prepared schedule\n4- At the end of the agreement between the two parties after a year, the shareholder may obtain an estimated total profit At 50,400 Algerian dinars, with the return of his capital (50,000 DZD), which gives him a profitable interest that exceeds 100%. (Ratios apply to each shareholder from another country)\n5- The institution is committed to disbursing profits to the shareholder according to a prior schedule that is sent to the person concerned via The e-mail with a consideration period of ten days after the earnings accrual date in each cycle\n6- The shareholder obtains his profits through an agent approved by our institution or directly from the institution and bears the responsibility Expenses and services for that process\n7- New quota deposits will be accepted according to a schedule prepared in advance to specify the quota deposit dates And the disbursement of profits based on the financial reports of the institution\n8- Each share is considered independent in terms of the dates of deposit, dividend payment, termination or renewal\n9- The shareholder is obligated not to claim a refund of the stake(s) for a full year starting from the date of the share(s).\nThe first deposit, except for the most exceptional cases, which are determined within the framework of a follow-up committee that includes supervisors and agents.\n10- At the end of the year, the Foundation shall return the money deposited by the contributor in the form of sums of money or Products in the event that the contributor decides not to renew or decides not to renew it, within 60 days of The end date of the agreement\n11- The shareholder can transfer ownership of his shares to another party after reviewing the proxy and correspondence The institution that retains the final decision in acceptance or rejection. In case of acceptance, an email will be sent Canceling the agreement for the old shareholder and writing to the new shareholder with a new agreement that he signs and returns send it to the institution\n12- This agreement is completely independent of any other activities of the Foundation such as training courses or any other activities Other activity The profits do not include any additional amounts other than what was agreed upon in the third item\n13- The shareholder does not have any obligations towards the various activities of the Corporation, nor does he have the right In interfering with the workflow within it, regardless of the number of shares involved in the fund.\n14- The official means of communication is the email, where the contributor receives a detailed email containing all the data Quotas, dates of deposit and disbursement of profits at the beginning of his participation and at the end of each 45-day cycle At the end of the agreement or its renewal, and everything related to any developments, and any means of communication or communication shall not be considered another correspondence. The data in this application is considered official and a reference for follow-up and updating\n15- When the shareholder and the corporation agree to renew the shares after the end of the year, an agreement is drawn up new between them.',
                                  style: TextStyle(
                                      color: screen_mode_map[screen_mode]),
                                ),
                              ]),
                            ));
                      });
                }),
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
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Transition(
                          user_theme: user_theme,
                        )));
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation1,
                        Animation<double> animation2) {
                      return SharesPage(
                        user_theme: user_theme,
                        screen_mode: screen_mode,
                        shares_data: shares_data.toList(),
                        is_valid: share_count != 0,
                      );
                    },
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
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
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Transition(
                            user_theme: user_theme,
                          )));
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

    final screen_mode_logo_and_beta = Align(
        alignment: Alignment.topRight,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: is_loaded ? 0.6 : 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Beta',
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontFamilyFallback: <String>[
                      'Noto Sans CJK SC',
                      'Noto Color Emoji',
                    ],
                    fontStyle: FontStyle.italic,
                    color: screen_mode_map[screen_mode]),
              ),
              IconButton(
                  onPressed: change_screen_mode,
                  icon: Icon(
                    screen_mode == Colors.white
                        ? Icons.mode_night_outlined
                        : Icons.wb_sunny_outlined,
                    size: 30,
                    color: screen_mode == Colors.white
                        ? Colors.blueGrey
                        : Colors.white,
                  )),
            ],
          ),
        ));

    Widget title_left(data) => AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: is_loaded ? 1 : 0,
          curve: Curves.fastOutSlowIn,
          child: AnimatedPadding(
            padding: EdgeInsets.only(right: is_loaded ? 3 : 30),
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: (Text(data,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: screen_mode_map[screen_mode],
                ))),
          ),
        );

    Widget title_right(data) => AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: is_loaded ? 1 : 0,
          curve: Curves.fastOutSlowIn,
          child: AnimatedPadding(
            padding: EdgeInsets.only(left: is_loaded ? 3 : 30),
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: (Text(data,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: screen_mode_map[screen_mode],
                ))),
          ),
        );

    final loading_circle = Center(
      child: Visibility(
        visible: is_loaded,
        child: Container(
          height: 50,
          width: 50,
          child: LoadingIndicator(
              strokeWidth: 3,
              colors: [theme_map[user_theme]?[0] as Color],
              indicatorType: Indicator.circleStrokeSpin),
        ),
      ),
    );

    final coming_soon = Center(
        child: Container(
      child: Text(
        'Coming Soon!',
        style: TextStyle(fontSize: 23, color: theme_map[user_theme]?[0]),
      ),
    ));

    final init_ind = Center(
      child: Visibility(
        visible: big_loading_ind,
        child: Container(
          height: 200,
          width: 200,
          child: LoadingIndicator(
              strokeWidth: 5,
              colors: [Colors.blueGrey],
              indicatorType: Indicator.circleStrokeSpin),
        ),
      ),
    );

    final bank_ind = share_count == 0
        ? Center(
            child: Container(
            child: Text(
              'No Active Shares!',
              style: TextStyle(fontSize: 23, color: theme_map[user_theme]?[0]),
            ),
          ))
        : Center(
            child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: theme_map[user_theme]![0],
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Shares: ${share_count} (${shares_val} DZD)',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Profit: ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${profit}',
                            style: TextStyle(
                                color: Color.fromARGB(255, 69, 247, 69)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Transition(
                            user_theme: user_theme,
                          )));
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return SharesPage(
                          user_theme: user_theme,
                          screen_mode: screen_mode,
                          shares_data: shares_data.toList(),
                          is_valid: share_count != 0,
                        );
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: theme_map[user_theme]![0],
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Go To AFT Bank\nDashboard',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ));

    return !home_initialized
        ? SpinKitCubeGrid(color: Colors.deepOrange)
        : GestureDetector(
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
                            fontSize:
                                (display_name + display_second_name).length > 26
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
                            fontSize:
                                (display_name + display_second_name).length > 20
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
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Transition(
                                  user_theme: user_theme,
                                )));
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
                                user_theme: user_theme,
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
                          user_theme = new_info[5];
                        });
                        MaterialColor new_theme;
                      },
                      child: CircleAvatar(
                          radius: 16, backgroundImage: profile_pic),
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
                body: Stack(
                  children: <Widget>[
                    background_logo,
                    big_loading_ind
                        ? init_ind
                        : ListView(children: [
                            screen_mode_logo_and_beta,
                            SizedBox(height: 10),
                            Center(
                                child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                title_left('AFT'),
                                title_right('News')
                              ],
                            )),
                            SizedBox(
                              height: 20,
                            ),
                            loading_ind_finish ? coming_soon : loading_circle,
                            SizedBox(
                              height: 80,
                            ),
                            Center(
                                child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                title_left('Trending'),
                                title_right('Products')
                              ],
                            )),
                            SizedBox(
                              height: 20,
                            ),
                            loading_ind_finish ? coming_soon : loading_circle,
                            SizedBox(
                              height: 80,
                            ),
                            Center(
                                child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [title_left('My'), title_right('Bank')],
                            )),
                            SizedBox(
                              height: 20,
                            ),
                            loading_ind_finish ? bank_ind : loading_circle,
                          ]),
                    side_menu,
                  ],
                )),
          );
  }
}
