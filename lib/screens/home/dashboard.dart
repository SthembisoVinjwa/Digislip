import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Container(
          padding: const EdgeInsets.only(
              left: 5.0, right: 5.0, bottom: 5.0, top: 0.0),
          alignment: Alignment.center,
          child: Card(
              elevation: 5.0,
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.all(12),
              child: ListView(padding: const EdgeInsets.all(20), children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: Theme.of(context).cardColor,
                    height: 200,
                  ),
                ),
              ]))),
    );
  }
}
