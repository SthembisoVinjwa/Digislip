import 'package:flutter/material.dart';

import '../../services/auth.dart';

class Reciepts extends StatefulWidget {
  const Reciepts({Key? key}) : super(key: key);

  @override
  State<Reciepts> createState() => _RecieptsState();
}

class _RecieptsState extends State<Reciepts> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Receipts'),
            TextButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text('Sign Out',),
            ),
          ],
        ),
      ),
    );
  }
}
