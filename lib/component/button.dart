import 'package:flutter/material.dart';

class RoundeButton extends StatelessWidget {
  RoundeButton({this.title, this.color, this.onPressed});
  final Color? color;
  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(15.0),
      child: MaterialButton(
        onPressed: onPressed!,
        minWidth: 400,
        height: 60.0,
        child: Text(
          title!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: "Roboto",
          ),
        ),
      ),
    );
  }
}
