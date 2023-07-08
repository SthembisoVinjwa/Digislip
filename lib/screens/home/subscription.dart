import 'package:flutter/material.dart';

import '../../services/auth.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Subscription'),
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
