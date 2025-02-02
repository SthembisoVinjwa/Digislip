import 'package:digislip/screens/home/dashboard/dashboard.dart';
import 'package:digislip/screens/home/dashboard/items/reciepts/receipts.dart';
import 'package:digislip/screens/home/menu/menu.dart';
import 'package:digislip/screens/home/menu/terms_and_conditions.dart';
import 'package:digislip/screens/home/subscription/subscription.dart';
import 'package:digislip/screens/provider/provider.dart';
import 'package:digislip/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'account/account.dart';
import 'dashboard/items/codes/codes.dart';
import 'dashboard/items/upload/upload.dart';
import 'dashboard/items/vouchers/vouchers.dart';
import 'menu/about.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int navIndex = 1;
  int pageIndex = 1;
  late List<Widget> screens;

  void toPage(int val) {
    setState(() {
      if (val <= 3) {
        navIndex = val;
        pageIndex = navIndex;
      } else {
        pageIndex = val;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the screens for navigation bar
    screens = <Widget>[
      Menu(toPage: toPage),
      Dashboard(toPage: toPage),
      Subscription(toPage: toPage,),
      Account(toPage: toPage),
      Receipts(toPage: toPage),
      Upload(toPage: toPage),
      Codes(toPage: toPage,),
      Vouchers(toPage: toPage),
      TermsAndConditions(toPage: toPage),
      About(toPage: toPage),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).cardColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 17.0, right: 17.0, bottom: 17.0),
        child: Container(
          height: 70,
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
                const TextStyle(
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
              height: 70,
              selectedIndex: navIndex,
              onDestinationSelected: (index) =>
                  toPage(index),
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
                  icon: Icon(Icons.card_membership_rounded, size: 28, color: Colors.white),
                  label: 'Subscription',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_2_rounded, size: 28, color: Colors.white),
                  label: 'Account',
                ),
              ],
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider<MainProvider>(
          create: (context) => MainProvider(),
          child: Consumer<MainProvider>(
            builder: (context, provider, _) {
              return screens[pageIndex];
            },
          ),
      ),
    );
  }
}