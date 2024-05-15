import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hint;

  const MyTextField({required this.hint, Key? key}) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  //bool _isTextFieldFocused = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Color.fromRGBO(90, 90, 90, 1)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Color.fromRGBO(90, 90, 90, 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Color.fromRGBO(90, 90, 90, 1),
          ),
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Color.fromRGBO(90, 90, 90, 1),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      /*onChanged: (value) {
        setState(() {
          _isTextFieldFocused = value.isNotEmpty;
        });
      },*/
    );
  }
}
