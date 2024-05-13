import 'package:flutter/material.dart';

class MyFilledButton extends StatefulWidget {
  final String text;
  const MyFilledButton({super.key, required this.text});

  @override
  State<MyFilledButton> createState() => _MyFilledButtonState();
}

class _MyFilledButtonState extends State<MyFilledButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      child: Text(
        widget.text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.normal,
          fontSize: 18,
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll<Color>(Color.fromRGBO(51, 132, 198, 1))),
    );
  }
}
