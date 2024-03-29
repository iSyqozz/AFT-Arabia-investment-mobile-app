import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';
import 'utils/transition.dart';
import 'verify.dart';
import 'package:provider/provider.dart';
import 'services/database.dart';

class ProfileEditPage extends StatefulWidget {
  String name1;
  String name2;
  String number;
  Color screen_mode;
  String pfp_url;
  String user_theme;

  ProfileEditPage({
    super.key,
    this.name1 = '',
    this.name2 = '',
    this.number = '',
    required this.screen_mode,
    required this.pfp_url,
    required this.user_theme,
  });
  _ProfileEditPage createState() => new _ProfileEditPage();
}

class _ProfileEditPage extends State<ProfileEditPage>
    with TickerProviderStateMixin {
  @override
  final _formkey = GlobalKey<FormState>();
  final first_name_controller = TextEditingController();
  final second_name_controller = TextEditingController();
  final number_controller = TextEditingController();
  String in_use = '';
  bool _is_visible = false;
  bool _is_error_vis = false;
  bool changed = false;

  IconData pass_ind = Icons.remove_red_eye_outlined;
  bool is_hidden = true;
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
    final user = Provider.of<User?>(context);
    //print(widget.pfp_url);

    final title = Text(
      'Personal Info',
      textAlign: TextAlign.center,
      style:
          TextStyle(fontSize: 40, color: screen_mode_map[widget.screen_mode]),
    );

    final name_label = Text(
      //name lable and field
      '    First Name:',
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
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
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
      decoration: InputDecoration(
        hintText: widget.screen_mode == Colors.white ? 'Joe' : '',
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

    //second name lable and field
    final second_name_label = Text(
      '    Second Name:',
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
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
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
      autofocus: false,
      decoration: InputDecoration(
        hintText: widget.screen_mode == Colors.white ? 'Smith' : '',
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

    //number lable and field
    final number_label = Text(
      '    Number:',
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
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
      style: TextStyle(color: screen_mode_map[widget.screen_mode]),
      autofocus: false,
      decoration: InputDecoration(
        hintText: widget.screen_mode == Colors.white ? 'xxx-xxxxxxx' : '',
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

    //Register Button Widget
    final Save_button = Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 80),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: theme_map[widget.user_theme]![0]),
          child: Text('Save', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              final res = await DatabaseService(uid: user?.uid as String)
                  .update_user_data(
                      first_name_controller.text,
                      second_name_controller.text,
                      number_controller.text,
                      widget.pfp_url,
                      widget.user_theme);
              if (res != null) {
                widget.name1 = first_name_controller.text;
                widget.name2 = second_name_controller.text;
                widget.number = number_controller.text;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Profile Info Saved!',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.teal,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'An Error has Accord, Try again later.',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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
              backgroundColor: theme_map[widget.user_theme]![0]),
          child: Text('Return', style: TextStyle(color: Colors.white)),
          onPressed: () {
            final List<String> res = [
              widget.name1,
              widget.name2,
              widget.number
            ];
            Navigator.pop(context, res);
          }),
    );

    // creating main scaffold container, putting everything together, and returning the the page
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: widget.screen_mode,
          body: Center(
            child: Form(
                key: _formkey,
                child: ListView(
                  shrinkWrap: false,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    SizedBox(height: 100.0),
                    title,
                    SizedBox(height: 80.0),
                    name_label,
                    name,
                    SizedBox(height: 15.0),
                    second_name_label,
                    second_name,
                    SizedBox(height: 15.0),
                    number_label,
                    number,
                    SizedBox(height: 20.0),
                    Save_button,
                    return_button,
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                )),
          ),
        ));
  }
}
