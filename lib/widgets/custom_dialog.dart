import 'package:flutter/material.dart';
import 'package:now_pills/constants.dart';

class CustomDialog extends StatelessWidget {
  final String title, body, actionBtnText;
  final Function()? onTap;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.body,
    required this.onTap,
    required this.actionBtnText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(body),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onTap,
          child: Text(actionBtnText, style: const TextStyle(color: mainColor)),
        ),
      ],
    );
  }
}
