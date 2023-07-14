import 'package:digislip/models/user.dart';
import 'package:digislip/models/user_data.dart';
import 'package:digislip/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      return StreamProvider<UserData?>.value(
          value: DatabaseService(uid: user!.uid, email: user.email!).userData,
          initialData: null,
          child: const Home(),
      );
    }
  }
}