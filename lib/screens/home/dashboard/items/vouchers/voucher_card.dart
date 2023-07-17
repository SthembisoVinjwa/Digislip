import 'package:barcode_widget/barcode_widget.dart';
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 10),
        child: SingleChildScrollView(
          child: Card(
            elevation: 0,
            margin: const EdgeInsets.only(top: 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 9, right: 9, bottom: 15),
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
                          '${widget.voucher['Merchantname']} - ${widget.voucher['Storename']}',
                          style: TextStyle(
                              color: Theme.of(context).cardColor, fontSize: 16),
                        ),
                        subtitle: Text(
                          '${widget.voucher['Voucherdate']} @ ${widget.voucher['Vouchertime']}',
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
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                        color: Theme.of(context).primaryColor,
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Voucher# ${widget.voucher['Vouchernumber']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                        const SizedBox(height: 36),
                        Container(
                          padding: const EdgeInsets.all(15),
                          color: Theme.of(context).cardColor,
                          height: 200,
                          child: BarcodeWidget(
                            backgroundColor: Theme.of(context).cardColor,
                            barcode: Barcode.code128(),
                            data: widget.voucher['Vouchernumber']!,
                            drawText: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
