import 'package:digislip/screens/provider/provider.dart';
import 'package:digislip/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  final Function toPage;

  const Menu({Key? key, required this.toPage}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final AuthService _auth = AuthService();

  List<ItemModel> items = [
    ItemModel("Dashboard", Icons.home_rounded),
    ItemModel("Receipts", Icons.receipt_long_rounded),
    ItemModel("Upload", Icons.cloud_upload_rounded),
    ItemModel("Subscription", Icons.local_offer_rounded),
    ItemModel("Account", Icons.person_2_rounded),
    ItemModel("Terms and Conditions", Icons.description_rounded),
    ItemModel("About", Icons.info_rounded),
    ItemModel("Sign Out", Icons.logout_rounded),
  ];

  @override
  Widget build(BuildContext context) {
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
          child: Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items.elementAt(index);
                bool separate =
                    item.title == 'Account' || item.title == 'About';
                if (separate) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (item.title == 'Account') {
                            widget.toPage(3);
                          } else if (item.title == 'About') {
                            widget.toPage(9);
                          }
                        },
                        child: Container(
                          height: 70,
                          // Adjust the height of the cards as needed
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Icon(item.Icon,
                                    color: Theme.of(context).primaryColor),
                                const SizedBox(width: 10),
                                Text(item.title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 5,
                        child: const Divider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  );
                }

                final provider = Provider.of<MainProvider>(context);
                bool isSubscribed = provider.isSubscribed;

                return GestureDetector(
                  onTap: () async {
                    if (item.title == 'Sign Out') {
                      await _auth.signOut();
                    } else if (item.title == 'Dashboard') {
                      widget.toPage(1);
                    } else if (item.title == 'Subscription') {
                      widget.toPage(2);
                    } else if (item.title == 'Receipts') {
                      widget.toPage(4);
                    }else if (item.title == 'Upload') {
                      if (isSubscribed) {
                        widget.toPage(5);
                      } else {
                        widget.toPage(2);
                      }
                    } else if (item.title == 'Codes') {
                      widget.toPage(6);
                    } else if (item.title == 'Vouchers') {
                      widget.toPage(7);
                    } else if (item.title == 'Terms and Conditions') {
                      widget.toPage(8);
                    }
                  },
                  child: Container(
                    height: 70, // Adjust the height of the cards as needed
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(item.Icon,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 10),
                          Text(
                            item.title,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ItemModel {
  final String title;
  final Icon;

  ItemModel(this.title, this.Icon);
}
