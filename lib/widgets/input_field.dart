import 'package:flutter/material.dart';
import 'package:now_pills/constants.dart';

class CustomBtn extends StatefulWidget {
  final Function onClick;
  final String title;

  const CustomBtn({
    Key? key,
    required this.onClick,
    required this.title
  }) : super(key: key);

  @override
  State<CustomBtn> createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => isClicked = true);
        animate();
        widget.onClick();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Container(
          width: 270,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              !isClicked
                  ? BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(-3, 4),
                    )
                  : const BoxShadow(),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 12,
          ),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void animate() {
    Future.delayed(
      const Duration(milliseconds: 350),
      () {
        setState(() => isClicked = false);
      },
    );
  }
}
