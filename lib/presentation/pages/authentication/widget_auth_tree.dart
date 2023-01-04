import 'package:flutter/material.dart';
import '../../../data/dataproviders/firebase_auth.dart';
import '../home_page.dart';
import 'login_register_page.dart';

class WidgetAuthTree extends StatefulWidget {
  const WidgetAuthTree({Key? key}) : super(key: key);

  @override
  State<WidgetAuthTree> createState() => _WidgetAuthTreeState();
}

class _WidgetAuthTreeState extends State<WidgetAuthTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
