import 'package:flutter/material.dart';

class ReceiptCard extends StatefulWidget {
  final Map<String, String> receipt;
  final List<Map<String, String>> receiptLines;
  final Function previous;

  ReceiptCard(
      {required this.receipt,
      required this.receiptLines,
      required this.previous});

  @override
  State<ReceiptCard> createState() => _ReceiptCardState();
}

class _ReceiptCardState extends State<ReceiptCard> {
  double tax = 0.15;

  double calculateSubtotal() {
    double subtotal = 0;
    for (var line in widget.receiptLines) {
      double amount = double.tryParse(line['Amount'] ?? '0') ?? 0;
      double quantity = double.tryParse(line['Qty'] ?? '0') ?? 0;
      subtotal += amount * quantity;
    }
    return subtotal;
  }

  double calculateTotal() {
    double subtotal = calculateSubtotal();
    double total = subtotal + subtotal * tax;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    widget.receiptLines.sort((a, b) {
      final lineNumberA = int.tryParse(a['Linenumber'] ?? '') ?? 0;
      final lineNumberB = int.tryParse(b['Linenumber'] ?? '') ?? 0;
      return lineNumberA.compareTo(lineNumberB);
    });

    final receiptNumber = widget.receipt['Receiptnumber'] ?? '';
    final formattedReceiptNumber = receiptNumber.contains('.')
        ? receiptNumber.split('.').first
        : receiptNumber;

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
                    padding:
                        const EdgeInsets.only(left: 9, right: 9, bottom: 15),
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
                          '${widget.receipt['Merchantname']} - ${widget.receipt['Storename']}',
                          style: TextStyle(
                              color: Theme.of(context).cardColor, fontSize: 16),
                        ),
                        subtitle: Text(
                          '${widget.receipt['Receiptdate']} @ ${widget.receipt['Receipttime']}',
                          style: TextStyle(
                              color: Theme.of(context).cardColor, fontSize: 12),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              widget.previous();
                            },
                            icon: Icon(Icons.cancel_rounded,
                                size: 30, color: Theme.of(context).cardColor)),
                        // Customize the UI for each receipt item as needed
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                        color: Theme.of(context).primaryColor,
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Receipt# $formattedReceiptNumber',
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
                        left: 18, right: 18, top: 5, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.receiptLines.map((line) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                        '${line['Qty']} x ${line['Description']}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('\$${line['Amount']}'),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              'Subtotal: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              '\$${calculateSubtotal().toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Tax: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              '\$${(calculateSubtotal() * 0.15).toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Total: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              '\$${calculateTotal().toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
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
