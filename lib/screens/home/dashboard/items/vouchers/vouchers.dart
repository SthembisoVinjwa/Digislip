import 'package:digislip/models/user.dart';
import 'package:digislip/components/loading.dart';
import 'package:digislip/screens/home/dashboard/items/vouchers/voucher_card.dart';
import 'package:digislip/services/auth.dart';
import 'package:digislip/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Vouchers extends StatefulWidget {
  final Function toPage;

  const Vouchers({Key? key, required this.toPage}) : super(key: key);

  @override
  State<Vouchers> createState() => _VouchersState();
}

class _VouchersState extends State<Vouchers> {
  final AuthService _auth = AuthService();
  bool viewVoucher = false;
  Map<String, String>? selectedVoucher;
  String imageUrl = '';
  bool sortDescending = true;

  void toReceitList() {
    setState(() {
      viewVoucher = false;
      selectedVoucher = {};
    });
  }

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
                if (!viewVoucher)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (viewVoucher) {
                              toReceitList();
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
                              'View Voucher',
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
                viewVoucher
                    ? selectedVoucher!['Type'] == 'Upload'
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
                                        selectedVoucher!['Storename']!.isEmpty
                                            ? selectedVoucher!['Merchantname']!
                                            : '${selectedVoucher!['Merchantname']} - ${selectedVoucher!['Storename']}',
                                        style: TextStyle(
                                            color:
                                            Theme.of(context).cardColor,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        selectedVoucher!['Vouchertime']!.isEmpty
                                            ? selectedVoucher!['Voucherdate']!
                                            : '${selectedVoucher!['Voucherdate']} @ ${selectedVoucher!['Vouchertime']}',
                                        style: TextStyle(
                                            color:
                                            Theme.of(context).cardColor,
                                            fontSize: 12),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            toReceitList();
                                          },
                                          icon: Icon(Icons.cancel_rounded,
                                              size: 30,
                                              color:
                                                  Theme.of(context).cardColor)),
                                      // Customize the UI for each receipt item as needed
                                    ),
                                  ),
                                ),
                                /*Container(
                        child: FutureBuilder<String>(
                          future: DatabaseService(
                              uid: user!.uid,
                              email: user.email!)
                              .getReceiptImage(
                              selectedVoucher!['Data'] ??
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
                                  'Error loading voucher image');
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
                                    Text('Loading Voucher...'),
                                    SizedBox(height: 60),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      )*/
                              ],
                            ),
                          )
                        : StreamBuilder<List<Map<String, String>>>(
                            stream: DatabaseService(
                                    uid: user!.uid, email: user.email!)
                                .getVouchers(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return VoucherCard(
                                  previous: toReceitList,
                                  voucher: selectedVoucher!,
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
                                        message: 'Loading Voucher...',
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
                                .getVouchers(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            final List<Map<String, String>> vouchers =
                                snapshot.data!;
                            if (sortDescending) {
                              vouchers.sort((a, b) {
                                DateTime dateA = DateFormat('dd/MM/yyyy').parse(a['Voucherdate']!);
                                DateTime dateB = DateFormat('dd/MM/yyyy').parse(b['Voucherdate']!);

                                if (dateB.isBefore(dateA)) {
                                  return -1; // b is before a
                                } else if (dateA.isBefore(dateB)) {
                                  return 1; // a is before b
                                } else {
                                  if (a['Vouchertime']!.isEmpty) {
                                    return 0;
                                  }

                                  TimeOfDay timeA = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(a['Vouchertime']!));
                                  TimeOfDay timeB = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(b['Vouchertime']!));

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
                              vouchers.sort((a, b) {
                                DateTime dateA = DateFormat('dd/MM/yyyy').parse(a['Voucherdate']!);
                                DateTime dateB = DateFormat('dd/MM/yyyy').parse(b['voucherdate']!);

                                if (dateB.isBefore(dateA)) {
                                  return 1; // b is before a (reverse order)
                                } else if (dateA.isBefore(dateB)) {
                                  return -1; // a is before b (reverse order)
                                } else {
                                  if (a['Vouchertime']!.isEmpty) {
                                    return 0;
                                  }

                                  TimeOfDay timeA = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(a['Vouchertime']!));
                                  TimeOfDay timeB = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(b['Vouchertime']!));

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
                              itemCount: vouchers.length,
                              itemBuilder: (context, index) {
                                final voucher = vouchers[index];
                                return Container(
                                  padding: const EdgeInsets.only(
                                      left: 7, right: 7, bottom: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedVoucher = voucher;
                                        viewVoucher = true;
                                      });
                                    },
                                    child: Card(
                                      color: Theme.of(context)
                                          .primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          voucher['Storename']!.isEmpty
                                              ? voucher['Merchantname']!
                                              : '${voucher['Merchantname']} - ${voucher['Storename']}',
                                          style: TextStyle(
                                              color:
                                              Theme.of(context).cardColor,
                                              fontSize: 16),
                                        ),
                                        subtitle: Text(
                                          voucher['Vouchertime']!.isEmpty
                                              ? voucher['Voucherdate']!
                                              : '${voucher['Voucherdate']} @ ${voucher['Vouchertime']}',
                                          style: TextStyle(
                                              color:
                                              Theme.of(context).cardColor,
                                              fontSize: 12),
                                        ),
                                        trailing: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Theme.of(context).cardColor),
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
                                  'No Vouchers',
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
                                    message: 'Loading Vouchers...',
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
