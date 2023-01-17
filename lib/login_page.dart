import 'package:flutter/material.dart';
import 'package:cool_app/register_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Example@abc.com',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //Login Button Widget
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Log In', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pushNamed(HomePage.tag);
          }),
    );

    //Register Button Widget
    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.deepOrangeAccent),
          child: Text('Register', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pushNamed(HomePage.tag);
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

    // creating main scaffold container, putting everything together, and returning the the page
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
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
              ],
            ),
          ),
        ));
  }
}
