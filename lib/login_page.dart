import 'package:flutter/material.dart';
import 'package:aft_arabia/services/auth.dart';
import 'register_page.dart';

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

  // Create a controller

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: false);

  // Create an animation with value of type "double"
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Color.fromARGB(0, 180, 32, 32),
        radius: 48.0,
        child: Image.asset(
            'lib/images/png-clipart-hamburger-button-computer-icons-marmon-keystone-canada-menu-red-sea.png'),
      ),
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
      obscureText: true,
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
                  error = 'Check Internet Connection';
                });
              } else if (res == 1) {
                setState(() {
                  _is_error_vis = true;
                  error = 'Email or Password Incorrect';
                });
              }

              _controller.stop();
              setState(() {
                _is_visible = false;
              });
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
          onPressed: () {
            Navigator.of(context).pushNamed(RegisterPage.tag);
          }),
    );

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
                  SizedBox(height: 150.0),
                  logo,
                  SizedBox(height: 48.0),
                  email_label,
                  SizedBox(height: 4.0),
                  email,
                  SizedBox(height: 8.0),
                  password_label,
                  SizedBox(height: 4.0),
                  password,
                  SizedBox(height: 24.0),
                  loginButton,
                  registerButton,
                  SizedBox(height: 20.0),
                  error_prompt,
                  SizedBox(height: 40.0),
                  Loading_ind,
                ],
              ),
            ),
          ),
        ));
  }
}
