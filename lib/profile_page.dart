import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'change-email.dart';
import 'utils/transition.dart';
import 'profile_edit_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'services/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  String name1;
  String name2;
  String number;
  String current_uid;
  Color screen_mode;
  ImageProvider home_file_path;
  String pfp_url;
  String user_theme;
  ProfilePage({
    super.key,
    required this.name1,
    required this.name2,
    required this.number,
    required this.current_uid,
    required this.home_file_path,
    required this.screen_mode,
    required this.pfp_url,
    required this.user_theme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double scr_width = 0;
  double scr_hight = 0;

  DateTime creationtime_date =
      FirebaseAuth.instance.currentUser?.metadata.creationTime as DateTime;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final _image_auth = FirebaseStorage.instance.ref();
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
  double buttons_width = 20;
  double button_offset = 20;
  bool buttons_opacity = false;

  Map<Color, Color> screen_mode_map = {
    Colors.white: Colors.black,
    Color.fromARGB(66, 78, 74, 74): Colors.white,
  };
  Map<String, List<Color>> theme_map = {
    'orange': [Colors.deepOrangeAccent, Colors.deepOrange],
    'purple': [Color.fromARGB(255, 40, 21, 92), Color.fromARGB(255, 29, 7, 66)],
    'teal': [Colors.teal, Color.fromARGB(255, 1, 92, 83)],
  };

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
                Timer mytimer = Timer(Duration(milliseconds: 200), (() {
                  setState(() {
                    buttons_opacity = true;
                    button_offset = 0;
                  });
                }));
              }));
            }));
          });
        }));
      });
    });
  }

  void set_theme(String theme) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Container(
                child: SpinKitCubeGrid(
              color: theme_map[widget.user_theme]![0],
              duration: Duration(milliseconds: 1000),
            ))));
    final res = await DatabaseService(uid: widget.current_uid).update_user_data(
        widget.name1, widget.name2, widget.number, widget.pfp_url, theme);
    Navigator.of(context).pop();
    print(res);
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Done!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.teal,
      ));
      setState(() {
        widget.user_theme = theme;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Error while setting theme',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.current_uid);
    print(widget.pfp_url);
    print(widget.user_theme);
    this.scr_width = MediaQuery.of(context).size.width;
    final back_arrow = GestureDetector(
      onTap: () {
        final List<dynamic> res = [
          widget.name1,
          widget.name2,
          widget.number,
          widget.home_file_path,
          widget.pfp_url,
          widget.user_theme,
        ];

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
            backgroundColor: widget.screen_mode,
            child: Icon(
              Icons.keyboard_arrow_left_outlined,
              size: 30,
            ),
          ),
        ),
      ),
    );

    final name_ind = AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: pic_visible ? 1 : 0,
      curve: Curves.fastOutSlowIn,
      child: AnimatedPadding(
        padding: EdgeInsets.fromLTRB(0, 0, name_x, 0),
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: (Text(widget.name1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (widget.name1 + widget.name2).length < 25 ? 20 : 12,
              color: screen_mode_map[widget.screen_mode],
            ))),
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
        child: (Text(widget.name2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (widget.name1 + widget.name2).length < 25 ? 20 : 12,
              color: screen_mode_map[widget.screen_mode],
            ))),
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
          style: TextStyle(fontSize: 15, color: Colors.blueGrey),
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
          border: Border.all(color: theme_map[widget.user_theme]![0], width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.name1,
                style: TextStyle(color: screen_mode_map[widget.screen_mode]),
              ),
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
          style: TextStyle(fontSize: 15, color: Colors.blueGrey),
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
          border: Border.all(color: theme_map[widget.user_theme]![0], width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.name2,
                style: TextStyle(color: screen_mode_map[widget.screen_mode]),
              ),
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
          style: TextStyle(fontSize: 15, color: Colors.blueGrey),
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
          border: Border.all(color: theme_map[widget.user_theme]![0], width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.number,
                style: TextStyle(color: screen_mode_map[widget.screen_mode]),
              ),
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
          style: TextStyle(fontSize: 15, color: Colors.blueGrey),
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
          border: Border.all(color: theme_map[widget.user_theme]![0], width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                formatter.format(creationtime_date),
                style: TextStyle(color: screen_mode_map[widget.screen_mode]),
              ),
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
          style: TextStyle(fontSize: 15, color: Colors.blueGrey),
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
          border: Border.all(color: theme_map[widget.user_theme]![0], width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                FirebaseAuth.instance.currentUser?.email.toString() as String,
                style: TextStyle(color: screen_mode_map[widget.screen_mode]),
              ),
            ),
          ),
        ),
      ),
    );

    final info_col = Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
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

    final change_email_button = GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Transition(
                  user_theme: widget.user_theme,
                )));
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return ChangeEmail(
                screen_mode: widget.screen_mode,
                user_theme: widget.user_theme,
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: AnimatedPadding(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.only(right: button_offset),
        child: AnimatedOpacity(
          opacity: buttons_opacity ? 1 : 0,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 300),
          child: Container(
            width: scr_width / 1.8,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme_map[widget.user_theme]![0],
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.email_outlined,
                  color: screen_mode_map[widget.screen_mode],
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Change E-mail Address',
                  style: TextStyle(
                      color: screen_mode_map[widget.screen_mode], fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );

    final edit_personal_info = GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Transition(
                  user_theme: widget.user_theme,
                )));
        List<String> new_info = await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return ProfileEditPage(
                name1: widget.name1,
                name2: widget.name2,
                number: widget.number,
                screen_mode: widget.screen_mode,
                pfp_url: widget.pfp_url,
                user_theme: widget.user_theme,
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        setState(() {
          widget.name1 = new_info[0];
          widget.name2 = new_info[1];
          widget.number = new_info[2];
        });
      },
      child: AnimatedPadding(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.only(right: button_offset),
        child: AnimatedOpacity(
          opacity: buttons_opacity ? 1 : 0,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 500),
          child: Container(
            width: scr_width / 1.8,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme_map[widget.user_theme]![0],
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.person, color: screen_mode_map[widget.screen_mode]),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Edit Profile Info',
                  style: TextStyle(
                      color: screen_mode_map[widget.screen_mode], fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );

    final change_theme = GestureDetector(
      onTap: (() {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    set_theme('purple');
                  },
                  tileColor: widget.screen_mode == Colors.white
                      ? Colors.white
                      : Colors.black87,
                  iconColor: Color.fromARGB(255, 29, 7, 66),
                  leading: new Icon(Icons.circle),
                  trailing: widget.user_theme == 'purple'
                      ? Icon(Icons.check,
                          color: screen_mode_map[widget.screen_mode])
                      : SizedBox(
                          width: 1,
                        ),
                  title: new Text('Deep Purple',
                      style: TextStyle(
                          color: screen_mode_map[widget.screen_mode])),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();

                    set_theme('orange');
                  },
                  tileColor: widget.screen_mode == Colors.white
                      ? Colors.white
                      : Colors.black87,
                  iconColor: Colors.deepOrange,
                  leading: new Icon(Icons.circle),
                  trailing: widget.user_theme == 'orange'
                      ? Icon(Icons.check,
                          color: screen_mode_map[widget.screen_mode])
                      : SizedBox(
                          width: 1,
                        ),
                  title: new Text('Deep Orange',
                      style: TextStyle(
                          color: screen_mode_map[widget.screen_mode])),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    set_theme('teal');
                  },
                  tileColor: widget.screen_mode == Colors.white
                      ? Colors.white
                      : Colors.black87,
                  iconColor: Colors.teal,
                  trailing: widget.user_theme == 'teal'
                      ? Icon(Icons.check,
                          color: screen_mode_map[widget.screen_mode])
                      : SizedBox(
                          width: 1,
                        ),
                  leading: new Icon(Icons.circle),
                  title: new Text('Teal',
                      style: TextStyle(
                          color: screen_mode_map[widget.screen_mode])),
                ),
              ]);
            });
      }),
      child: AnimatedPadding(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.only(right: button_offset),
        child: AnimatedOpacity(
          opacity: buttons_opacity ? 1 : 0,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 100),
          child: Container(
            width: scr_width / 1.8,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme_map[widget.user_theme]![0],
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.color_lens,
                  color: screen_mode_map[widget.screen_mode],
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Change Theme',
                  style: TextStyle(
                      color: screen_mode_map[widget.screen_mode], fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
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
                  border: Border.all(
                      color: theme_map[widget.user_theme]![0], width: 4),
                  borderRadius: BorderRadius.all(Radius.circular(60))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Profile Info',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                  ),
                  info_col,
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  edit_personal_info,
                  SizedBox(
                    height: 5,
                  ),
                  change_email_button,
                  SizedBox(
                    height: 5,
                  ),
                  change_theme,
                ],
              ),
            )),
      ),
    );

    final pic = GestureDetector(
      onTap: (() {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    tileColor: widget.screen_mode == Colors.white
                        ? Colors.white
                        : Colors.black87,
                    iconColor: screen_mode_map[widget.screen_mode],
                    leading: new Icon(Icons.photo),
                    title: new Text('Change Profile Picture',
                        style: TextStyle(
                            color: screen_mode_map[widget.screen_mode])),
                    onTap: () async {
                      Navigator.pop(context);
                      final file = await showDialog(
                          context: context,
                          builder: ((context) {
                            var _imageFile = null;
                            final storage_ref = FirebaseStorage.instance;
                            String image_url = '';
                            var _uploadTask;
                            Future<XFile?> _pick_image(
                                ImageSource source) async {
                              return await ImagePicker.platform
                                  .getImage(source: source);
                            }

                            void _start_upload() async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Container(
                                          child: SpinKitCubeGrid(
                                        color: theme_map[widget.user_theme]![0],
                                        duration: Duration(milliseconds: 1000),
                                      ))));
                              try {
                                DatabaseService my_database =
                                    DatabaseService(uid: widget.current_uid);
                                print(
                                    'upload started go and check the storage');
                                String filepath =
                                    'Profile Pictures/${widget.current_uid}.png';
                                _uploadTask = await storage_ref
                                    .ref()
                                    .child(filepath)
                                    .putFile(File(_imageFile.path));
                                image_url = await storage_ref
                                    .ref()
                                    .child(filepath)
                                    .getDownloadURL();
                                bool res =
                                    await my_database.update_profile_photo(
                                        widget.name1,
                                        widget.name2,
                                        widget.number,
                                        image_url,
                                        widget.user_theme);
                                Navigator.of(context).pop();
                                if (res == false) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      'Failed to Update Profile Picture',
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Colors.red,
                                  ));
                                  print(
                                      'adding download link to firestore failed');
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      'Done!',
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Colors.teal,
                                  ));
                                  print('upload susccessful');
                                  Navigator.of(context).pop([
                                    FileImage(File(_imageFile.path)),
                                    image_url
                                  ]);
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'Failed to Update Profile Picture',
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.red,
                                ));
                                print(e.toString());
                              }
                            }

                            Future<CroppedFile?> _crop_image() async {
                              return await ImageCropper.platform.cropImage(
                                sourcePath: _imageFile?.path,
                              );
                            }

                            void clear() {
                              setState(() {
                                _imageFile = null;
                              });
                            }

                            return StatefulBuilder(
                                builder: ((context, setState) {
                              return AlertDialog(
                                  title: Center(child: Text('Upload Photo')),
                                  content: _imageFile == null
                                      ? Container(
                                          height: 200,
                                          width: 300,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                      onTap: (() async {
                                                        XFile? selected =
                                                            await _pick_image(
                                                                ImageSource
                                                                    .gallery);
                                                        if (selected != null) {
                                                          final temp =
                                                              await selected
                                                                  .length();
                                                          print(temp);
                                                          if (temp > 2097152) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  'Image Size greater than  2MB !!'),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ));
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        }
                                                        setState(() {
                                                          _imageFile = selected;
                                                        });
                                                      }),
                                                      child: Icon(
                                                        Icons.photo,
                                                        size: 30,
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('Upload from device'),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Text(
                                                'Max file size: 2 MB',
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(
                                          height: 200,
                                          width: 300,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 243, 240, 240),
                                                backgroundImage: FileImage(
                                                    File(_imageFile.path)),
                                                radius: 50,
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _start_upload();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: theme_map[widget
                                                            .user_theme]![1],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    70)),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                          'Save',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final cropped =
                                                          await _crop_image();
                                                      setState(() {
                                                        _imageFile = cropped ??
                                                            _imageFile;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: theme_map[widget
                                                            .user_theme]![1],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    70)),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                          'Edit Image',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    70)),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                          'Cancel',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ));
                            }));
                          }));
                      if (file != null) {
                        setState(() {
                          setState(() {
                            widget.home_file_path = file[0];
                            widget.pfp_url = file[1];
                          });
                        });
                      }
                    },
                  ),
                  ListTile(
                    iconColor: screen_mode_map[widget.screen_mode],
                    leading: new Icon(Icons.delete_forever),
                    tileColor: widget.screen_mode == Colors.white
                        ? Colors.white
                        : Colors.black87,
                    title: new Text('Remove Profile Picture',
                        style: TextStyle(
                            color: screen_mode_map[widget.screen_mode])),
                    onTap: () async {
                      if (widget.pfp_url == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'No profile Picture to Delete!',
                              textAlign: TextAlign.center,
                            )));
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Container(
                                    child: SpinKitCubeGrid(
                                  color: theme_map[widget.user_theme]![0],
                                  duration: Duration(milliseconds: 1000),
                                ))));
                        try {
                          DatabaseService my_database =
                              DatabaseService(uid: widget.current_uid);
                          String filepath =
                              'Profile Pictures/${widget.current_uid}.png';
                          final ref = await FirebaseStorage.instance
                              .ref()
                              .child(filepath);
                          await ref.delete();
                          bool res = await my_database.update_profile_photo(
                              widget.name1,
                              widget.name2,
                              widget.number,
                              '',
                              widget.user_theme);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();

                          if (res == false) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Failed to Delete Profile Picture',
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.red,
                            ));
                            print('adding download link to firestore failed');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Done!',
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.teal,
                            ));
                            setState(() {
                              widget.home_file_path = Image.asset(
                                'lib/images/pfp-placeholder.jpg',
                                fit: BoxFit.contain,
                              ).image;
                              widget.pfp_url = '';
                            });
                            print('change susccessful');
                          }
                        } catch (e) {
                          print(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Failed to Delete Profile Picture',
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    },
                  ),
                ],
              );
            });
      }),
      child: Padding(
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
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        )),
                  ),
                  radius: 90,
                  backgroundImage: widget.home_file_path),
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
          backgroundColor: widget.screen_mode,
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
                            color: theme_map[widget.user_theme]![0],
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
