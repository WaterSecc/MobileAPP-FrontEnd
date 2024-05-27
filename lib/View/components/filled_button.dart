import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyFilledButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const MyFilledButton(
      {super.key, required this.text, required this.onPressed});

  @override
  State<MyFilledButton> createState() => _MyFilledButtonState();
}

class _MyFilledButtonState extends State<MyFilledButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: Text(
        widget.text,
        style: TextStyles.ListHeaderStyle(white),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll<Color>(Theme.of(context).cardColor)),
      onPressed: widget.onPressed,
    );
  }
}
