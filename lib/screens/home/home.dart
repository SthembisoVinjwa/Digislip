import 'package:digislip/screens/home/dashboard.dart';
import 'package:digislip/screens/home/menu.dart';
import 'package:digislip/screens/home/profile.dart';
import 'package:digislip/screens/home/subscription.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int navIndex = 1;

  // Screens for navigation bar
  final screens = <Widget>[
    const Menu(),
    const Dashboard(),
    const Subscription(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 17.0, right: 17.0, bottom: 17.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              indicatorColor:
              Theme.of(context).colorScheme.secondary,
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            child: NavigationBar(
              labelBehavior:
              NavigationDestinationLabelBehavior.onlyShowSelected,
              animationDuration: const Duration(seconds: 2),
              height: 60,
              selectedIndex: navIndex,
              onDestinationSelected: (index) =>
                  setState(() => navIndex = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.menu_rounded, size: 28, color: Colors.white),
                  label: 'Menu',
                ),
                NavigationDestination(
                  icon: Icon(Icons.home_rounded, size: 28, color: Colors.white),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.check_circle_rounded, size: 28, color: Colors.white),
                  label: 'Subscription',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_2_rounded, size: 28, color: Colors.white),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
      body: screens[navIndex],
    );
  }
}