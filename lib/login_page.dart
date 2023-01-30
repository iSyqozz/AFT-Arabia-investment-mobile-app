import 'package:flutter/material.dart';
import 'package:aft_arabia/services/auth.dart';
import 'register_page.dart';
import 'dart:async';
import 'reset_pass_page.dart';
import 'verify.dart';
import 'utils/transition.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final AuthService _login_checker = AuthService();
  final _formkey = GlobalKey<FormState>();
  final login_email_controller = TextEditingController();
  final login_password_controller = TextEditingController();
  bool _is_visible = false;
  bool _is_error_vis = false;
  String error = '';
  IconData pass_ind = Icons.remove_red_eye_outlined;
  bool is_hidden = true;

  void remove(AnimationController e) {
    e.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    // Create an animation with value of type "double"
    late final Animation<double> _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    final logo = Image.asset(
      'lib/images/logo.png',
      height: 400,
      width: 400,
    );

    final email = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val!)) {
          return 'Please Enter Valid Email Address';
        } else if (val.length > 320) {
          return "This Field Can't Have more than 20 characters";
        } else {
          return null;
        }
      },
      controller: login_email_controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Example@abc.com',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
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
      controller: login_password_controller,
      autofocus: false,
      obscureText: is_hidden,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //loading spinning indicator
    final Loading_ind = Visibility(
      visible: _is_visible,
      child: Stack(children: [
        Center(
          child: RotationTransition(
            turns: _animation,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Wrap(
                children: [
                  Container(
                    width: 10,
                    height: 20,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(8),
                            topLeft: Radius.circular(20)),
                        color: Colors.deepOrange,
                        shape: BoxShape.rectangle),
                  ),
                  Container(
                    width: 30,
                    height: 20,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                  Container(
                    width: 30,
                    height: 20,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                  Container(
                    width: 10,
                    height: 20,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(8)),
                        color: Colors.deepOrange,
                        shape: BoxShape.rectangle),
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
            child: Text('Signing\nin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.teal,
                )))
      ]),
    );
    //Login Button Widget
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 90),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Log In', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              setState(() {
                _is_visible = true;
                _is_error_vis = false;
              });
              _controller.repeat();
              await Future.delayed(Duration(seconds: 1));
              dynamic res = await _login_checker.signIn(
                  login_email_controller.text, login_password_controller.text);
              if (res == null) {
                setState(() {
                  _is_error_vis = true;
                  _is_visible = false;
                  error = 'Check Internet Connection';
                });
              } else if (res == 1) {
                setState(() {
                  _is_visible = false;
                  _is_error_vis = true;
                  error = 'Email or Password Incorrect';
                });
              } else {
                if (!res.emailVerified) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VerifyPage()));
                }
                setState(() {
                  _is_error_vis = false;
                  _is_visible = false;
                });
                remove(_controller);
              }
            }
          }),
    );

    //Register Button Widget
    final registerButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 90),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(12),
                backgroundColor: Colors.deepOrangeAccent),
            child: Text('Register', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Transition(
                        user_theme: 'orange',
                      )));
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation1,
                      Animation<double> animation2) {
                    return RegisterPage();
                  },
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }));

    //email prompt
    final email_label = Text(
      '    E-mail:',
      style: TextStyle(color: Colors.black54),
    );

    //password prompt
    final password_label = Text(
      '    Password:',
      style: TextStyle(color: Colors.black54),
    );

    final error_prompt = Visibility(
      visible: _is_error_vis,
      child: Center(
        child: Text(
          error,
          style: TextStyle(color: Colors.red, fontSize: 15.0),
        ),
      ),
    );

    final reset_pwd_button = Row(
      children: [
        Text(
          'Forgot Password?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blueGrey,
          ),
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Transition(
                      user_theme: 'orange',
                    )));
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return ResetPassPage(
                    screen_mode: Colors.white,
                    user_theme: 'orange',
                  );
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          child: Text(
            '  Tap Here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.lightBlueAccent),
          ),
        )
      ],
    );

    // creating main scaffold container, putting everything together, and returning the the page
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _formkey,
            child: Center(
              child: ListView(
                shrinkWrap: false,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  logo,
                  email_label,
                  SizedBox(height: 4.0),
                  email,
                  SizedBox(height: 8.0),
                  password_label,
                  SizedBox(height: 4.0),
                  password,
                  Row(children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (pass_ind == Icons.remove_red_eye_outlined) {
                            pass_ind = Icons.remove_red_eye_sharp;
                          } else {
                            pass_ind = Icons.remove_red_eye_outlined;
                          }
                          is_hidden = !is_hidden;
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
                          login_email_controller.text = '';
                          login_password_controller.text = '';
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Icon(Icons.delete_forever_sharp),
                      ),
                    )
                  ]),
                  SizedBox(height: 10.0),
                  loginButton,
                  registerButton,
                  SizedBox(height: 20.0),
                  error_prompt,
                  SizedBox(height: 20.0),
                  Loading_ind,
                  SizedBox(height: 40.0),
                  reset_pwd_button
                ],
              ),
            ),
          ),
        ));
  }
}
