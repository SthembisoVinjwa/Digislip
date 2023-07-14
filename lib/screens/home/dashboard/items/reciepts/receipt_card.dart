import 'package:flutter/material.dart';

class ReceiptCard extends StatelessWidget {
  final List<Map<String, String>> receiptLines;
  final Map<String, String> receipt;

  ReceiptCard({required this.receiptLines, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Receipt Number: ${receipt['Receiptnumber']}', // Assuming receiptData is a list, access the first receipt's 'Receiptnumber'
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Merchant ID: ${receipt['Merchantid']}'), // Assuming merchantId is the same for all receipt lines
            SizedBox(height: 8),
            Text('Store Name: ${receipt['Storename']}'), // Assuming storeName is the same for all receipt lines
            SizedBox(height: 8),
            Text('Receipt Date: ${receipt['Receiptdate']}'), // Assuming receiptDate is the same for all receipt lines
            SizedBox(height: 8),
            Text('Type: ${receipt['Type']}'), // Assuming type is the same for all receipt lines
            SizedBox(height: 16),
            Text(
              'Receipt Lines:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: receiptLines.map((line) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text('Amount: ${line['Amount']}'),
                    Text('Description: ${line['Description']}'),
                    Text('Line Number: ${line['Linenumber']}'),
                    Text('Quantity: ${line['Qty']}'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}