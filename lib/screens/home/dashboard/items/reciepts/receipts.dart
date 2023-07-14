import 'package:digislip/models/user.dart';
import 'package:digislip/models/user_data.dart';
import 'package:digislip/screens/authenticate/loading.dart';
import 'package:digislip/screens/home/dashboard/items/reciepts/receipt_card.dart';
import 'package:digislip/services/auth.dart';
import 'package:digislip/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Receipts extends StatefulWidget {
  final Function toPage;

  const Receipts({Key? key, required this.toPage}) : super(key: key);

  @override
  State<Receipts> createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts> {
  final AuthService _auth = AuthService();
  bool viewReceipt = false;
  Map<String, String>? selectedReceipt;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    children: [
                      if (!viewReceipt)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (viewReceipt) {
                                    setState(() {
                                      viewReceipt = false;
                                      selectedReceipt = {};
                                    });
                                  } else {
                                    widget.toPage(1);
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'View Receipt',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              IconButton(
                                // Just for padding
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      viewReceipt
                          ? selectedReceipt!['Type'] == 'Upload'
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            bottom: 10,
                                            top: 15),
                                        child: Card(
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              selectedReceipt!['Storename'] ??
                                                  '',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  fontSize: 16),
                                            ),
                                            subtitle: Text(
                                              selectedReceipt!['Receiptdate'] ??
                                                  '',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  fontSize: 12),
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    viewReceipt = false;
                                                    selectedReceipt = {};
                                                  });
                                                },
                                                icon: Icon(Icons.cancel_rounded,
                                                    size: 30,
                                                    color: Theme.of(context)
                                                        .cardColor)),
                                            // Customize the UI for each receipt item as needed
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: FutureBuilder<String>(
                                          future: DatabaseService(
                                                  uid: user!.uid,
                                                  email: user.email!)
                                              .getReceiptImage(
                                                  selectedReceipt!['Data'] ??
                                                      ''),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Container(
                                                height: 385,
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    snapshot.data!,
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  'Error loading receipt image');
                                            } else {
                                              return Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Loading(), // Loading indicator widget
                                                    SizedBox(height: 30),
                                                    Text('Loading Receipt...'),
                                                    SizedBox(height: 60),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            bottom: 10,
                                            top: 15),
                                        child: Card(
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              selectedReceipt!['Storename'] ??
                                                  '',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  fontSize: 16),
                                            ),
                                            subtitle: Text(
                                              selectedReceipt!['Receiptdate'] ??
                                                  '',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  fontSize: 12),
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    viewReceipt = false;
                                                    selectedReceipt = {};
                                                  });
                                                },
                                                icon: Icon(Icons.cancel_rounded,
                                                    size: 30,
                                                    color: Theme.of(context)
                                                        .cardColor)),
                                            // Customize the UI for each receipt item as needed
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: FutureBuilder<List<Map<String, String>>>(
                                          future: DatabaseService(
                                                  uid: user!.uid,
                                                  email: user.email!)
                                              .getLines(selectedReceipt!['Receiptid']!),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return ReceiptCard(receiptLines: snapshot.data!, receipt: selectedReceipt!,);
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            } else {
                                              return Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Loading(), // Loading indicator widget
                                                    SizedBox(height: 30),
                                                    Text('Loading Receipt...'),
                                                    SizedBox(height: 60),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                          : Expanded(
                              child: StreamBuilder<List<Map<String, String>>>(
                              stream: DatabaseService(
                                      uid: user!.uid, email: user.email!)
                                  .getReceipts(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  final List<Map<String, String>> receipts =
                                      snapshot.data!;
                                  receipts.sort((a, b) {
                                    DateTime dateA;
                                    DateTime dateB;

                                    dateA = DateFormat('dd/MM/yyyy')
                                        .parse(a['Receiptdate']!);
                                    dateB = DateFormat('dd/MM/yyyy')
                                        .parse(b['Receiptdate']!);

                                    return dateB.compareTo(dateA);
                                  });
                                  return ListView.builder(
                                    itemCount: receipts.length,
                                    itemBuilder: (context, index) {
                                      final receipt = receipts[index];
                                      return Container(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, bottom: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedReceipt = receipt;
                                              viewReceipt = true;
                                            });
                                          },
                                          child: Card(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                receipt['Storename'] ?? '',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    fontSize: 16),
                                              ),
                                              subtitle: Text(
                                                receipt['Receiptdate'] ?? '',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    fontSize: 12),
                                              ),
                                              trailing: Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                              // Customize the UI for each receipt item as needed
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError ||
                                    snapshot.data != null) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No Receipts',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 70,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Loading(),
                                        // Loading indicator widget
                                        SizedBox(height: 30),
                                        Text('Loading Receipts...'),
                                        // Optional text to display
                                      ],
                                    ),
                                  );
                                }
                              },
                            )),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
