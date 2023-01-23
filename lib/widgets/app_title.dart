import 'package:flutter/material.dart';
import 'package:now_pills/constants.dart';

class AppTitle extends StatelessWidget {
  final double top;

  const AppTitle({Key? key, required this.top}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "NowPills",
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
            shadows: [mainShadow],
          ),
        ),
      ),
    );
  }
}
