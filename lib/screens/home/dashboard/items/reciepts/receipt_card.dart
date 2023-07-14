import 'package:flutter/material.dart';

class ReceiptCard extends StatefulWidget {
  final Map<String, String> receipt;
  final List<Map<String, String>> receiptLines;
  final Function previous;

  ReceiptCard({required this.receipt, required this.receiptLines, required this.previous});

  @override
  State<ReceiptCard> createState() => _ReceiptCardState();
}

class _ReceiptCardState extends State<ReceiptCard> {
  double tax = 0.0;

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
    double total = subtotal + tax;
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
    final formattedReceiptNumber =
    receiptNumber.contains('.') ? receiptNumber.split('.').first : receiptNumber;

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
                padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 15),
                child: Card(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      widget.receipt['Storename'] ??
                          '',
                      style: TextStyle(
                          color: Theme.of(context)
                              .cardColor,
                          fontSize: 16),
                    ),
                    subtitle: Text(
                      widget.receipt['Receiptdate'] ??
                          '',
                      style: TextStyle(
                          color: Theme.of(context)
                              .cardColor,
                          fontSize: 12),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          widget.previous();
                        },
                        icon: Icon(Icons.cancel_rounded,
                            size: 30,
                            color: Theme.of(context)
                                .cardColor)),
                    // Customize the UI for each receipt item as needed
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
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
                                  'Receipt# ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                                Text(
                                  formattedReceiptNumber,
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
                                  '${widget.receipt['Receiptdate']}',
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
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Name: ${widget.receipt['Storename']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.receiptLines.map((line) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Amount: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text('${line['Amount']}'),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Description: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text('${line['Description']}'),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Line Number: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text('${line['Linenumber']}'),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Quantity: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text('${line['Qty']}'),
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
                          calculateSubtotal().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        const Text(
                          'Tax: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          '$tax',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        const Text(
                          'Total: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          calculateTotal().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
