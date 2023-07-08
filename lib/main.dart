import 'package:digislip/screens/wrapper.dart';
import 'package:digislip/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DigiSlips',
        theme: ThemeData(
          unselectedWidgetColor: Colors.white,
          brightness: Brightness.light,
          primaryColor: const Color(0xFF234F1E),
          canvasColor: Colors.green,
          cardColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
              .copyWith(secondary: const Color(0xFF5DBB63)),
        ),
        home: const Wrapper(),
      ),
    );
  }
}
