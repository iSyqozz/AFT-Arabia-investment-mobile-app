import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Transition extends StatelessWidget {
  const Transition({super.key});

  Timer Canceltransition(context) {
    return Timer(Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Canceltransition(context);

    return Container(
        child: SpinKitCubeGrid(
      color: Colors.deepOrangeAccent,
      duration: Duration(milliseconds: 1000),
    ));
    ;
  }
}
