import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Transition extends StatelessWidget {
  String user_theme;
  Transition({super.key, required this.user_theme});

  Timer Canceltransition(context) {
    return Timer(Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  Map<String, List<Color>> theme_map = {
    'orange': [Colors.deepOrangeAccent, Colors.deepOrange],
    'purple': [Color.fromARGB(255, 40, 21, 92), Color.fromARGB(255, 29, 7, 66)],
    'teal': [Colors.teal, Color.fromARGB(255, 1, 92, 83)],
  };

  @override
  Widget build(BuildContext context) {
    Canceltransition(context);

    return Container(
        child: SpinKitCubeGrid(
      color: theme_map[user_theme]?[1],
      duration: Duration(milliseconds: 1000),
    ));
    ;
  }
}
