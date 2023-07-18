import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final String message;

  const Loading({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Center(
        child: Column(
          children: [
            SpinKitFoldingCube(
              color: Theme.of(context).primaryColor,
              size: 54.0,
            ),
            const SizedBox(height: 30),
            Text(
              message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
