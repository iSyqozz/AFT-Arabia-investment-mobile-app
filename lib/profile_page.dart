import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  String name1;
  String name2;
  String number;
  //String email;
  ProfilePage({
    super.key,
    required this.name1,
    required this.name2,
    required this.number,
    //required this.email,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime creationtime_date =
      FirebaseAuth.instance.currentUser?.metadata.creationTime as DateTime;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final auth = FirebaseAuth.instance.currentUser;
  bool is_built = false;
  double cover_hight = 0;
  double cover_width = 0;
  bool cover_visible = false;
  bool info_visible = false;
  var border_rad = BorderRadius.only(
      bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0));
  double pic_rad = 0;
  bool pic_visible = false;
  var pic_align = Alignment.topCenter;
  double arrow_x = 60;
  double name_x = 70;

  double _info_border_hight = 80;
  bool fields_left_visible = false;

  //page initial animations
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        is_built = true;
        cover_hight = MediaQuery.of(context).size.height / 4;
        cover_visible = true;
        cover_width = MediaQuery.of(context).size.width;
        border_rad = BorderRadius.only(
            bottomLeft: Radius.circular(200),
            bottomRight: Radius.circular(200));
        Timer mytimer = Timer(Duration(milliseconds: 150), (() {
          setState(() {
            pic_visible = true;
            pic_rad = 90;
            pic_align = Alignment.bottomCenter;
            arrow_x = 10;
            name_x = 2;
            Timer mytimer = Timer(Duration(milliseconds: 100), (() {
              setState(() {
                _info_border_hight = 10;
                info_visible = true;
              });
              Timer mytimer = Timer(Duration(milliseconds: 300), (() {
                setState(() {
                  fields_left_visible = true;
                });
              }));
            }));
          });
        }));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final name_ind = AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: pic_visible ? 1 : 0,
      curve: Curves.fastOutSlowIn,
      child: AnimatedPadding(
        padding: EdgeInsets.fromLTRB(0, 0, name_x, 0),
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: (Text(
          widget.name1,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: (widget.name1 + widget.name2).length < 25 ? 20 : 12,
              color: Colors.black),
        )),
      ),
    );

    final second_name_ind = AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: pic_visible ? 1 : 0,
      curve: Curves.fastOutSlowIn,
      child: AnimatedPadding(
        padding: EdgeInsets.fromLTRB(name_x, 0, 0, 0),
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: (Text(
          widget.name2,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: (widget.name1 + widget.name2).length < 25 ? 20 : 12,
              color: Colors.black),
        )),
      ),
    );

    final back_arrow = GestureDetector(
      onTap: () {
        final List<String> res = [widget.name1, widget.name2, widget.number];

        Navigator.pop(context, res);
      },
      child: AnimatedOpacity(
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        opacity: pic_visible ? 1 : 0,
        child: AnimatedPadding(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 500),
          padding: new EdgeInsets.fromLTRB(arrow_x, 10, 0, 0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.keyboard_arrow_left_outlined,
              size: 30,
            ),
          ),
        ),
      ),
    );

    final first_name_label = Visibility(
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: fields_left_visible ? 1 : 0,
        curve: Curves.fastOutSlowIn,
        child: Text(
          'First Name:',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );

    final first_name = AnimatedOpacity(
      opacity: fields_left_visible ? 1 : 0,
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: 150,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.deepOrangeAccent, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(widget.name1),
            ),
          ),
        ),
      ),
    );

    final last_name_label = Visibility(
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: fields_left_visible ? 1 : 0,
        curve: Curves.fastOutSlowIn,
        child: Text(
          'Last Name:',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );

    final last_name = AnimatedOpacity(
      opacity: fields_left_visible ? 1 : 0,
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: 150,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.deepOrangeAccent, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(widget.name2),
            ),
          ),
        ),
      ),
    );
    final number_label = Visibility(
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: fields_left_visible ? 1 : 0,
        curve: Curves.fastOutSlowIn,
        child: Text(
          'Number:',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );

    final number = AnimatedOpacity(
      opacity: fields_left_visible ? 1 : 0,
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: 150,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.deepOrangeAccent, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(widget.number),
            ),
          ),
        ),
      ),
    );
    final creation_time = Visibility(
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: fields_left_visible ? 1 : 0,
        curve: Curves.fastOutSlowIn,
        child: Text(
          'Creation Time:',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
    final creation_time_info = AnimatedOpacity(
      opacity: fields_left_visible ? 1 : 0,
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: 150,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.deepOrangeAccent, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(formatter.format(creationtime_date)),
            ),
          ),
        ),
      ),
    );

    final email_label = Visibility(
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: fields_left_visible ? 1 : 0,
        curve: Curves.fastOutSlowIn,
        child: Text(
          'Email:',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
    final email_info = AnimatedOpacity(
      opacity: fields_left_visible ? 1 : 0,
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: 150,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.deepOrangeAccent, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(FirebaseAuth.instance.currentUser?.email.toString()
                  as String),
            ),
          ),
        ),
      ),
    );

    final info_col = Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 12,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                first_name_label,
                SizedBox(
                  width: 50,
                ),
                first_name
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                last_name_label,
                SizedBox(
                  width: 50,
                ),
                last_name,
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                number_label,
                SizedBox(
                  width: 68,
                ),
                number,
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                email_label,
                SizedBox(
                  width: 85,
                ),
                email_info
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                creation_time,
                SizedBox(
                  width: 30,
                ),
                creation_time_info,
              ],
            )
          ],
        ),
      ],
    );

    final info_section = AnimatedPadding(
      duration: Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
      padding: EdgeInsets.fromLTRB(0, _info_border_hight, 0, 0),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
        opacity: info_visible ? 1 : 0,
        child: Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height / 1.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.deepOrangeAccent, width: 4),
                  borderRadius: BorderRadius.all(Radius.circular(60))),
              child: info_col,
            )),
      ),
    );

    final pic = Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
          opacity: pic_visible ? 1 : 0,
          child: AnimatedAlign(
            alignment: pic_align,
            duration: Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
            child: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.edit_outlined)),
              ),
              radius: 90,
              backgroundImage:
                  Image.asset('lib/images/pfp-placeholder.jpg').image,
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ListView(
              children: [
                AnimatedOpacity(
                  duration: Duration(milliseconds: 600),
                  opacity: cover_visible ? 1 : 0,
                  child: Stack(
                    children: [
                      Center(
                        child: AnimatedContainer(
                          width: cover_width,
                          height: cover_hight,
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: border_rad,
                          ),
                          duration: Duration(milliseconds: 400),
                          curve: Curves.fastOutSlowIn,
                          child: pic,
                        ),
                      ),
                      back_arrow,
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [name_ind, second_name_ind],
                  ),
                ),
                SizedBox(
                  height: _info_border_hight,
                ),
                info_section,
              ],
            ),
          ),
        ));
  }
}
