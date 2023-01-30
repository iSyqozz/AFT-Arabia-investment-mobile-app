import 'dart:async';

import 'package:aft_arabia/contact_page.dart';
import 'package:aft_arabia/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'contact_page.dart';

class SharesPage extends StatefulWidget {
  String user_theme;
  Color screen_mode;
  Iterable shares_data;
  bool is_valid;

  SharesPage({
    super.key,
    required this.user_theme,
    required this.screen_mode,
    required this.shares_data,
    required this.is_valid,
  });

  @override
  State<SharesPage> createState() => _SharesPageState();
}

class _SharesPageState extends State<SharesPage> {
  bool big_loading_ind = true;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Timer mytimer = Timer(Duration(milliseconds: 1500), (() {
        setState(() {
          big_loading_ind = false;
        });
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    final init_ind = Center(
      child: Visibility(
        visible: big_loading_ind,
        child: Container(
          height: 200,
          width: 200,
          child: LoadingIndicator(
              strokeWidth: 5,
              colors: [Colors.blueGrey],
              indicatorType: Indicator.circleStrokeSpin),
        ),
      ),
    );

    final no_shares_title = Center(
      child: Text(
        'No Active Shares',
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 40, color: screen_mode_map[widget.screen_mode]),
      ),
    );

    final sub_text = Center(
      child: Text(
        'Interested in joining the AFT Investor Program?',
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 15, color: screen_mode_map[widget.screen_mode]),
      ),
    );

    final sub_text2 = Center(
      child: Text(
        'You will be re-routed to\nthe contact page ',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.blueGrey),
      ),
    );

    final yes_button = GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Transition(
                  user_theme: widget.user_theme,
                )));
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return ContactPage(
                screen_mode: widget.screen_mode,
                user_theme: widget.user_theme,
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: theme_map[widget.user_theme]![0],
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Yes!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    final no_button = GestureDetector(
      onTap: () async {
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
            color: theme_map[widget.user_theme]![0],
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Return',
            style: TextStyle(color: Colors.white),
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
          body: big_loading_ind
              ? init_ind
              : !widget.is_valid
                  ? ListView(
                      children: [],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        no_shares_title,
                        SizedBox(
                          height: 40,
                        ),
                        sub_text,
                        SizedBox(
                          height: 40,
                        ),
                        yes_button,
                        SizedBox(
                          height: 5,
                        ),
                        sub_text2,
                        SizedBox(
                          height: 30,
                        ),
                        no_button
                      ],
                    )),
    );
  }
}
