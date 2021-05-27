import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onPressed;

  ButtonWidget({
    this.color = Colors.blue,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: color,
      shape: StadiumBorder(),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child:
              Text(text!, style: TextStyle(fontSize: 17, color: Colors.white)),
        ),
      ),
    );
  }
}
