import 'package:digislip/services/auth.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  final Function toPage;
  const TermsAndConditions({Key? key, required this.toPage}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  final AuthService _auth = AuthService();

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
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
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
                                  widget.toPage(0);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Terms and conditions',
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
                          SizedBox(height: 16,),
                          Text(
                            'Welcome to DigiSlips, your digital receipt management app. '
                                'Keep track of your receipts, store them securely, and access them anytime, anywhere. '
                                'We are committed to providing a seamless and convenient experience for managing your receipts. '
                                'If you have any questions or feedback, please reach out to our support team.',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Text(
                            '2023 - Copyright - DigiSlips',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 16),
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