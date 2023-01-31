import 'dart:async';

import 'package:aft_arabia/contact_page.dart';
import 'package:aft_arabia/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:animated_digit/animated_digit.dart';

class SharesPage extends StatefulWidget {
  String user_theme;
  Color screen_mode;
  List shares_data;
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
  double summary_border_width = 2;
  double summary_circle_dimension = 0;
  double summary_profit_val = 0;
  double summary_share_count = 0;
  double summary_inactive_count = 0;
  bool summary_content_visible = false;
  double profit = 0;
  double share_count = 0;
  double inactive_share_count = 0;
  List<Color> back_ground = [Colors.purple, Colors.orange];
  Color inactive_color = Colors.blueGrey;

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
      for (var v in widget.shares_data) {
        if (v['status'] == 'Active') {
          profit += (double.parse(v['current profit'])) -
              6300 * double.parse(v['dividends']);
          share_count += 1;
        } else {
          inactive_share_count += 1;
        }
      }
      Timer mytimer = Timer(Duration(milliseconds: 1500), (() {
        setState(() {
          big_loading_ind = false;
        });
        Timer mytimer = Timer(Duration(milliseconds: 100), (() {
          setState(() {
            summary_border_width = 5;
            summary_circle_dimension = 200;
          });
          Timer mytimer = Timer(Duration(milliseconds: 600), (() {
            setState(() {
              summary_content_visible = true;
              summary_profit_val = profit;
              summary_share_count = share_count;
              summary_inactive_count = inactive_share_count;
              inactive_color = inactive_share_count != 0
                  ? Color.fromARGB(255, 131, 14, 23)
                  : Colors.blueGrey;
            });
          }));
        }));
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

    final dashboard_title = Center(
      child: Text(
        'Dashboard',
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 40, color: Color.fromARGB(255, 164, 191, 204)),
      ),
    );

    final summary_head = Center(
        child: AnimatedContainer(
            width: summary_circle_dimension,
            height: summary_circle_dimension,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
                border: Border.all(
                    width: summary_border_width,
                    color: Color.fromARGB(255, 168, 177, 182)),
                borderRadius: BorderRadius.all(Radius.circular(200))),
            child: Visibility(
              visible: summary_content_visible,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '+',
                          style: TextStyle(
                              color: Color.fromARGB(255, 27, 161, 32),
                              fontSize: 20),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        AnimatedDigitWidget(
                          value: summary_profit_val,
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 27, 161, 32),
                              fontSize: 20),
                          enableSeparator: true,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'DZD',
                          style: TextStyle(
                              color: Color.fromARGB(255, 27, 161, 32),
                              fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedDigitWidget(
                          value: summary_share_count,
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 27, 161, 32),
                              fontSize: 20),
                          enableSeparator: true,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Active shares',
                          style: TextStyle(
                              color: Color.fromARGB(255, 27, 161, 32),
                              fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedDigitWidget(
                          value: summary_inactive_count,
                          textStyle:
                              TextStyle(color: inactive_color, fontSize: 20),
                          enableSeparator: true,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Inactive shares',
                          style: TextStyle(color: inactive_color, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));

    final share_list = Visibility(
      visible: summary_content_visible,
      child: Container(
          height: 500,
          width: 300,
          child: ListView.builder(
            itemCount: widget.shares_data.length,
            itemBuilder: (context, index) {
              return ListTile(
                minVerticalPadding: 10,
                tileColor: widget.shares_data[index]['status'] == 'Inactive'
                    ? Color.fromARGB(48, 219, 35, 66)
                    : Color.fromARGB(49, 35, 247, 16),
                leading: CircleAvatar(
                  backgroundColor:
                      widget.shares_data[index]['status'] == 'Inactive'
                          ? Color.fromARGB(255, 131, 14, 23)
                          : Color.fromARGB(255, 3, 192, 13),
                  child: Text(
                    widget.shares_data[index]['status'],
                    style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(197, 255, 255, 255)),
                  ),
                ),
                title: Text('test'),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Text('Deposit Date: '),
                      Text(
                        '${widget.shares_data[index]['date started']}',
                        style: TextStyle(
                            color:
                                widget.shares_data[index]['status'] == 'Active'
                                    ? Color.fromARGB(255, 158, 180, 190)
                                    : Colors.black),
                      )
                    ]),
                    Row(children: [
                      Text('current cycle: '),
                      Text(
                        '${widget.shares_data[index]['cycles']}',
                        style: TextStyle(
                            color:
                                widget.shares_data[index]['status'] == 'Active'
                                    ? Color.fromARGB(255, 158, 180, 190)
                                    : Colors.black),
                      )
                    ]),
                    Row(children: [
                      Text('Total Cycles: '),
                      Text(
                        '${widget.shares_data[index]['total cycles']}',
                        style: TextStyle(
                            color:
                                widget.shares_data[index]['status'] == 'Active'
                                    ? Color.fromARGB(255, 158, 180, 190)
                                    : Colors.black),
                      )
                    ]),
                    Row(children: [
                      Text('Payed Dividends: '),
                      Text(
                        '${widget.shares_data[index]['dividends']}',
                        style: TextStyle(
                            color:
                                widget.shares_data[index]['status'] == 'Active'
                                    ? Color.fromARGB(255, 158, 180, 190)
                                    : Colors.black),
                      )
                    ]),
                    Row(children: [
                      Text('Profit: '),
                      Text(
                        '${widget.shares_data[index]['current profit']}',
                        style: TextStyle(
                            color:
                                widget.shares_data[index]['status'] == 'Active'
                                    ? Color.fromARGB(255, 0, 199, 17)
                                    : Colors.black),
                      )
                    ]),
                  ],
                ),
                trailing: Icon(Icons.more_vert),
              );
            },
          )),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.blueGrey,
              Colors.black,
            ])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 155, 165, 170),
                child: Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                }),
            body: big_loading_ind
                ? init_ind
                : widget.is_valid
                    ? ListView(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          dashboard_title,
                          SizedBox(
                            height: 10,
                          ),
                          summary_head,
                          SizedBox(
                            height: 30,
                          ),
                          share_list
                        ],
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
      ),
    );
  }
}
