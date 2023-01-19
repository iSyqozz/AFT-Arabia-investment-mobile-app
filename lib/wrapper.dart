import 'package:aft_arabia/home.dart';
import 'package:aft_arabia/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}
