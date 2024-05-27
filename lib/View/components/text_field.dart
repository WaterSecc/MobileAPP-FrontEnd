import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

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
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        hintText: widget.hint,
        hintStyle: TextStyles.subtitle3Style(Theme.of(context).colorScheme.secondary,),
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
