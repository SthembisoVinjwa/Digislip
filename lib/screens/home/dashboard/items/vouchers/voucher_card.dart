import 'package:flutter/material.dart';

class VoucherCard extends StatefulWidget {
  final Map<String, String> voucher;
  final Function previous;

  VoucherCard({required this.voucher, required this.previous});

  @override
  State<VoucherCard> createState() => _VoucherCardState();
}

class _VoucherCardState extends State<VoucherCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(top: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Card(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      widget.voucher['Terms'] ?? '',
                      style: TextStyle(
                          color: Theme.of(context).cardColor, fontSize: 14),
                    ),
                    subtitle: Text(
                      widget.voucher['Voucherdate'] ?? '',
                      style: TextStyle(
                          color: Theme.of(context).cardColor, fontSize: 12),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          widget.previous();
                        },
                        icon: Icon(Icons.cancel_rounded,
                            size: 30, color: Theme.of(context).cardColor)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  child: Container(
                    height: 73,
                    padding: const EdgeInsets.all(15.0),
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Voucher# ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                                Text(
                                  widget.voucher['Vouchernumber']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Date ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                                Text(
                                  '${widget.voucher['Voucherdate']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voucher terms: ${widget.voucher['Terms']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Expiry date: ${widget.voucher['Expirydate']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
