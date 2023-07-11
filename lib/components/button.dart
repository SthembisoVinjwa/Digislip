import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {

  final Function()? onTap;
  final Color color;
  final String title;
  final double margin;

  const MainButton({Key? key, required this.onTap, required this.color, required this.title, required this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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