import 'package:flutter/material.dart';

class MyTextBtn extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const MyTextBtn({super.key, required this.text, required this.onPressed});

  @override
  State<MyTextBtn> createState() => _MyTextBtnState();
}

class _MyTextBtnState extends State<MyTextBtn> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      child: Text(
        widget.text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.normal,
          fontSize: 18,
          color: Color.fromRGBO(51, 132, 198, 1),
        ),
      ),
      style: ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll<Color>(Color.fromRGBO(255, 255, 255, 1)),
        shadowColor:
            MaterialStatePropertyAll<Color>(Color.fromRGBO(51, 132, 198, 1)),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
            color:
                Color.fromRGBO(51, 132, 198, 1), // Set the border color to blue
            width: 2.3, // Set the border width (adjust as needed)
          ),
        ),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      ),
    );
  }
}
