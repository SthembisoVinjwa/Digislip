import 'package:barcode_widget/barcode_widget.dart';
import 'package:digislip/models/user.dart';
import 'package:digislip/screens/home/dashboard/dashboard_items.dart';
import 'package:digislip/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  final Function toPage;

  const Dashboard({Key? key, required this.toPage}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthService _auth = AuthService();
  bool barcode = true;

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
            const Row(
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
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
        alignment: Alignment.center,
        child: Card(
          elevation: 5.0,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  flex: 11,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          barcode = !barcode;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        color: Theme.of(context).cardColor,
                        height: 200,
                        child: BarcodeWidget(
                          backgroundColor: Theme.of(context).cardColor,
                          barcode: barcode? Barcode.code128() : Barcode.qrCode(),
                          data: user!.uid,
                          drawText: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
                Expanded(
                  flex: 16,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: DashboardItems(
                        toPage: widget.toPage,
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
