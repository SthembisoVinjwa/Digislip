import 'package:digislip/models/user.dart';
import 'package:digislip/components/loading.dart';
import 'package:digislip/screens/home/dashboard/items/reciepts/receipt_card.dart';
import 'package:digislip/screens/provider/provider.dart';
import 'package:digislip/services/auth.dart';
import 'package:digislip/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'fullscreen.dart';

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
  bool sortDescending = true;

  void toReceiptList() {
    setState(() {
      viewReceipt = false;
      selectedReceipt = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    final provider = Provider.of<MainProvider>(context);
    bool isSubscribed = provider.isSubscribed;

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
        alignment: Alignment.topCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                if (!viewReceipt)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (viewReceipt) {
                              toReceiptList();
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
                        Row(
                          children: [
                            IconButton(
                              // Just for padding
                              onPressed: () {
                                setState(() {
                                  sortDescending = !sortDescending;
                                });
                              },
                              icon: Icon(
                                sortDescending
                                    ? Icons.arrow_circle_up_rounded
                                    : Icons.arrow_circle_down_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 29,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
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
                                      left: 15, right: 15, bottom: 10, top: 15),
                                  child: Card(
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        selectedReceipt!['Storename']!.isEmpty
                                            ? selectedReceipt!['Merchantname']!
                                            : '${selectedReceipt!['Merchantname']} - ${selectedReceipt!['Storename']}',
                                        style: TextStyle(
                                            color:
                                            Theme.of(context).cardColor,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        selectedReceipt!['Receipttime']!.isEmpty
                                            ? selectedReceipt!['Receiptdate']!
                                            : '${selectedReceipt!['Receiptdate']} @ ${selectedReceipt!['Receipttime']}',
                                        style: TextStyle(
                                            color:
                                            Theme.of(context).cardColor,
                                            fontSize: 12),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            toReceiptList();
                                          },
                                          icon: Icon(Icons.cancel_rounded,
                                              size: 30,
                                              color:
                                                  Theme.of(context).cardColor)),
                                      // Customize the UI for each receipt item as needed
                                    ),
                                  ),
                                ),
                                FutureBuilder<String>(
                                  future: DatabaseService(
                                          uid: user!.uid, email: user.email!)
                                      .getReceiptImage(
                                          selectedReceipt!['Data'] ?? ''),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Navigate to a new screen to display the image in full screen
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenImage(
                                                      imageUrl: snapshot.data!),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 405,
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              snapshot.data!,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text(
                                          'Error loading receipt image');
                                    } else {
                                      return const Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Loading(
                                                message: 'Loading Receipt...'),
                                            // Loading indicator widget
                                            SizedBox(height: 60),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        : FutureBuilder<List<Map<String, String>>>(
                            future: DatabaseService(
                                    uid: user!.uid, email: user.email!)
                                .getLines(selectedReceipt!['Receiptid']!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ReceiptCard(
                                  receiptLines: snapshot.data!,
                                  receipt: selectedReceipt!,
                                  previous: toReceiptList,
                                );
                              } else if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              } else {
                                return const Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Loading(
                                        message: 'Loading Receipt...',
                                      ),
                                      // Loading indicator widget
                                      SizedBox(height: 60),
                                    ],
                                  ),
                                );
                              }
                            },
                          )
                    : Expanded(
                        child: StreamBuilder<List<Map<String, String>>>(
                        stream:
                            DatabaseService(uid: user!.uid, email: user.email!)
                                .getReceipts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            final List<Map<String, String>> receipts =
                                snapshot.data!;
                            if (!isSubscribed) {
                              receipts.removeWhere(
                                  (receipt) => receipt['Type'] == 'Upload');
                            }
                            if (sortDescending) {
                              receipts.sort((a, b) {
                                DateTime dateA = DateFormat('dd/MM/yyyy')
                                    .parse(a['Receiptdate']!);
                                DateTime dateB = DateFormat('dd/MM/yyyy')
                                    .parse(b['Receiptdate']!);

                                if (dateB.isBefore(dateA)) {
                                  return -1; // b is before a
                                } else if (dateA.isBefore(dateB)) {
                                  return 1; // a is before b
                                } else {
                                  if (a['Receipttime']!.isEmpty) {
                                    return 0;
                                  }
                                  TimeOfDay timeA = TimeOfDay.fromDateTime(
                                      DateFormat('HH:mm')
                                          .parse(a['Receipttime']!));
                                  TimeOfDay timeB = TimeOfDay.fromDateTime(
                                      DateFormat('HH:mm')
                                          .parse(b['Receipttime']!));

                                  if (timeB.hour < timeA.hour) {
                                    return -1; // b is before a
                                  } else if (timeA.hour < timeB.hour) {
                                    return 1; // a is before b
                                  } else {
                                    if (timeB.minute < timeA.minute) {
                                      return -1; // b is before a
                                    } else if (timeA.minute < timeB.minute) {
                                      return 1; // a is before b
                                    } else {
                                      return 0; // a and b are equal
                                    }
                                  }
                                }
                              });
                            } else {
                              receipts.sort((a, b) {
                                DateTime dateA = DateFormat('dd/MM/yyyy')
                                    .parse(a['Receiptdate']!);
                                DateTime dateB = DateFormat('dd/MM/yyyy')
                                    .parse(b['Receiptdate']!);

                                if (dateB.isBefore(dateA)) {
                                  return 1; // b is before a (reverse order)
                                } else if (dateA.isBefore(dateB)) {
                                  return -1; // a is before b (reverse order)
                                } else {
                                  if (a['Receipttime']!.isEmpty) {
                                    return 0;
                                  }
                                  TimeOfDay timeA = TimeOfDay.fromDateTime(
                                      DateFormat('HH:mm')
                                          .parse(a['Receipttime']!));
                                  TimeOfDay timeB = TimeOfDay.fromDateTime(
                                      DateFormat('HH:mm')
                                          .parse(b['Receipttime']!));

                                  if (timeB.hour < timeA.hour) {
                                    return 1; // b is before a (reverse order)
                                  } else if (timeA.hour < timeB.hour) {
                                    return -1; // a is before b (reverse order)
                                  } else {
                                    if (timeB.minute < timeA.minute) {
                                      return 1; // b is before a (reverse order)
                                    } else if (timeA.minute < timeB.minute) {
                                      return -1; // a is before b (reverse order)
                                    } else {
                                      return 0; // a and b are equal
                                    }
                                  }
                                }
                              });
                            }
                            return ListView.builder(
                              itemCount: receipts.length,
                              itemBuilder: (context, index) {
                                final receipt = receipts[index];
                                return Container(
                                  padding: const EdgeInsets.only(
                                      left: 7, right: 7, bottom: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedReceipt = receipt;
                                        viewReceipt = true;
                                      });
                                    },
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          receipt['Storename']!.isEmpty
                                              ? receipt['Merchantname']!
                                              : '${receipt['Merchantname']} - ${receipt['Storename']}',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).cardColor,
                                              fontSize: 16),
                                        ),
                                        subtitle: Text(
                                          receipt['Receipttime']!.isEmpty
                                              ? receipt['Receiptdate']!
                                              : '${receipt['Receiptdate']} @ ${receipt['Receipttime']}',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).cardColor,
                                              fontSize: 12),
                                        ),
                                        trailing: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Theme.of(context).cardColor),
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
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Loading(
                                    message: 'Loading Receipts...',
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
