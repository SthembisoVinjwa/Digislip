import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
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
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 28),
                SizedBox(width: 2),
                Text(
                  'DigiSlips',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Positioned(
              right: -10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 28,
                    ),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
          padding: const EdgeInsets.only(
              left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
          alignment: Alignment.center,
          child: Card(
              elevation: 5.0,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.all(12),
              child: ListView(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 20, top: 20),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        color: Theme.of(context).cardColor,
                        height: 200,
                        child: BarcodeWidget(
                          backgroundColor: Theme.of(context).cardColor,
                          barcode: Barcode.code128(),
                          data: user!.uid,
                          drawText: false,
                        ),
                      ),
                    ),
                  ]))),
    );
  }
}
