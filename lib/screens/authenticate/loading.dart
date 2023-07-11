import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Center(
        child: SpinKitFoldingCube(
          color: Theme.of(context).primaryColor,
          size: 54.0,
        ),
      ),
    );
  }
}
