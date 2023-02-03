import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';

import 'verify.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  @override
  final AuthService _register_checker = AuthService();
  final _formkey = GlobalKey<FormState>();
  final first_name_controller = TextEditingController();
  final second_name_controller = TextEditingController();
  final number_controller = TextEditingController();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final confirm_password_controller = TextEditingController();
  String in_use = '';
  bool _is_visible = false;
  bool _is_error_vis = false;

  IconData pass_ind = Icons.remove_red_eye_outlined;
  bool is_hidden = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 10),
    vsync: this,
  )..repeat(reverse: true);

  // Create an animation with value of type "double"
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  Widget build(BuildContext context) {
    final in_use_prompt = Visibility(
      visible: _is_error_vis,
      child: Center(
        child: Text(
          in_use,
          style: TextStyle(color: Colors.red, fontSize: 15.0),
        ),
      ),
    );

    final name_label = Text(
      //name lable and field
      '    First Name:',
      style: TextStyle(color: Colors.black54),
    );

    final name = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 20) {
          return "This Field Can't Have more than 20 characters";
        } else {
          return null;
        }
      },
      controller: first_name_controller,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Joe',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //second name lable and field
    final second_name_label = Text(
      '    Second Name:',
      style: TextStyle(color: Colors.black54),
    );

    final second_name = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 20) {
          return "This Field Can't Have more than 20 characters";
        } else {
          return null;
        }
      },
      controller: second_name_controller,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Smith',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //number lable and field
    final number_label = Text(
      '    Number:',
      style: TextStyle(color: Colors.black54),
    );

    final number = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val!.length > 20) {
          return "This Field Can't Have more than 20 Numbers";
        } else {
          return null;
        }
      },
      controller: number_controller,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'xxx-xxxxxxx',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //email lable and field
    final email_label = Text(
      '    E-mail:',
      style: TextStyle(color: Colors.black54),
    );

    final email = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val!)) {
          return 'Please Enter a Valid Email Address';
          ;
        } else if (val.length > 320) {
          return "This Field Can't Have more than 20 characters";
        } else {
          return null;
        }
      },
      controller: email_controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'example@abc.com',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //number lable and field
    final password_label = Text(
      '    Password:',
      style: TextStyle(color: Colors.black54),
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
      controller: password_controller,
      autofocus: false,
      obscureText: is_hidden,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //number lable and field
    final confirm_password_lable = Text(
      '    Confirm Password:',
      style: TextStyle(color: Colors.black54),
    );

    final confirm_password = TextFormField(
      validator: (val) {
        if (val == '') {
          return 'This Field Cannot Be Empty';
        } else if (val != password_controller.text) {
          return "Input Doesn't match Password";
        } else {
          return null;
        }
      },
      controller: confirm_password_controller,
      autofocus: false,
      obscureText: is_hidden,
      decoration: InputDecoration(
        hintText: 'password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //Register Button Widget
    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Finish Registeration',
              style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              setState(() {
                _is_visible = true;
                _is_error_vis = false;
              });
              _controller.repeat();
              await Future.delayed(Duration(seconds: 1));

              dynamic res = await _register_checker.SignUp(
                first_name_controller.text,
                second_name_controller.text,
                number_controller.text,
                email_controller.text,
                password_controller.text,
                'orange',
              );
              if (res == null) {
                setState(() {
                  in_use = 'Check Internet Connection';
                  _is_error_vis = true;
                });
              } else if (res == 1) {
                setState(() {
                  in_use = 'Email is already registered';
                  _is_error_vis = true;
                });
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => VerifyPage()));
                dispose();
                //print(res.uid);
                return null;
              }

              _controller.stop();
              setState(() {
                _is_visible = false;
              });
            }
          }),
    );

    final return_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Return', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

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
            child: Text('Signing\nup',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.teal,
                )))
      ]),
    );

    // creating main scaffold container, putting everything together, and returning the the page
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Form(
                key: _formkey,
                child: ListView(
                  shrinkWrap: false,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    SizedBox(height: 80.0),
                    name_label,
                    name,
                    SizedBox(height: 15.0),
                    second_name_label,
                    second_name,
                    SizedBox(height: 15.0),
                    number_label,
                    number,
                    SizedBox(height: 15.0),
                    email_label,
                    email,
                    SizedBox(height: 15.0),
                    password_label,
                    password,
                    SizedBox(height: 15.0),
                    confirm_password_lable,
                    confirm_password,
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
                            first_name_controller.text = '';
                            second_name_controller.text = '';
                            number_controller.text = '';
                            email_controller.text = '';
                            password_controller.text = '';
                            confirm_password_controller.text = '';
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Icon(Icons.delete_forever_sharp),
                        ),
                      )
                    ]),
                    SizedBox(height: 20.0),
                    registerButton,
                    return_button,
                    SizedBox(
                      height: 10.0,
                    ),
                    in_use_prompt,
                    SizedBox(
                      height: 30,
                    ),
                    Loading_ind
                  ],
                )),
          ),
        ));
  }
}
