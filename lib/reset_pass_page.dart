import 'package:flutter/material.dart';
import 'services/auth.dart';

class ResetPassPage extends StatefulWidget {
  Color screen_mode;
  String user_theme;
  ResetPassPage({
    super.key,
    required this.screen_mode,
    required this.user_theme,
  });

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  final AuthService resetter = AuthService();
  final _formkey = GlobalKey<FormState>();
  final _email_controller = TextEditingController();
  Map<Color, Color> screen_mode_map = {
    Colors.white: Colors.black,
    Color.fromARGB(66, 78, 74, 74): Colors.white,
  };
  Map<String, List<Color>> theme_map = {
    'orange': [Colors.deepOrangeAccent, Colors.deepOrange],
    'purple': [Color.fromARGB(255, 40, 21, 92), Color.fromARGB(255, 29, 7, 66)],
    'teal': [Colors.teal, Color.fromARGB(255, 1, 92, 83)],
  };
  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Reset Password',
      textAlign: TextAlign.center,
      style:
          TextStyle(fontSize: 40, color: screen_mode_map[widget.screen_mode]),
    );

    final details = Text(
      '- Provide your E-mail address in the field below.\n- Wait for the Confirmation E-mail to arrive in your inbox.\n- Click the link and follow the steps to reset you password.',
      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
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
          return "This Field Can't Have more than 320 characters";
        } else {
          return null;
        }
      },
      controller: _email_controller,
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: widget.screen_mode == Colors.white ? 'example@abc.com' : '',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
                color: screen_mode_map[widget.screen_mode] as Color)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final return_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: theme_map[widget.user_theme]![0]),
          child: Text('Return', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    final send_email_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: theme_map[widget.user_theme]![0]),
          child: Text('Send Email Link', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              dynamic res =
                  await resetter.resetPassword(_email_controller.text.trim());
              if (res != null) {
                print('sent!');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: SingleChildScrollView(
                    child: Text(
                      'Email Sent!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  backgroundColor: Colors.teal,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: SingleChildScrollView(
                    child: Text(
                      'Failed to send Email!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ));
              }
            }
          }),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: widget.screen_mode,
        body: Form(
          key: _formkey,
          child: ListView(
            shrinkWrap: false,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: [
              SizedBox(
                height: 200,
              ),
              title,
              SizedBox(
                height: 100,
              ),
              details,
              SizedBox(
                height: 10,
              ),
              email,
              SizedBox(
                height: 40,
              ),
              send_email_button,
              return_button
            ],
          ),
        ),
      ),
    );
  }
}
