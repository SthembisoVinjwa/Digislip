import 'package:digislip/screens/provider/provider.dart';
import 'package:digislip/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Subscription extends StatefulWidget {
  final Function toPage;

  const Subscription({Key? key, required this.toPage}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    bool isSubscribed = provider.isSubscribed;

    print(isSubscribed);

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
              children: const [
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      alignment: Alignment.topCenter,
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.toPage(1);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Subscription',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  //For padding
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 166,
                          ),
                          const Text('Subscribed',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Switch(
                            activeTrackColor: Colors.grey,
                            activeColor: Theme.of(context).canvasColor,
                            value: provider.isSubscribed,
                            onChanged: (bool value) {
                              setState(() {
                                provider.updateSubscription(value);
                              });
                            },
                          ),
                          const Spacer(),
                          const Text(
                            '2023 - Copyright - DigiSlips',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
