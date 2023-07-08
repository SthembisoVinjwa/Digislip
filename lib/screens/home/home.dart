import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    final AuthService _auth = AuthService();

    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            await _auth.signOut();
          },
          child: Text('Sign Out', style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}