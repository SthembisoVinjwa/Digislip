import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Function()? onTap;
  final Color color;
  final String title;
  final double margin;

  const MainButton(
      {Key? key,
      required this.onTap,
      required this.color,
      required this.title,
      required this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.height;
    final smallScreen = x < 700;

    return GestureDetector(
      onTap: onTap,
      child: smallScreen
          ? Container(
              height: 45,
              width: double.infinity,
              padding: const EdgeInsets.all(5.0),
              margin: EdgeInsets.symmetric(horizontal: margin),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )),
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(horizontal: margin),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ),
            ),
    );
  }
}
