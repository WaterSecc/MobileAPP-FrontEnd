import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

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
        style: TextStyles.ListHeaderStyle(Theme.of(context).colorScheme.secondary),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(
          Theme.of(context).colorScheme.background,
        ),
        shadowColor:
            MaterialStatePropertyAll<Color>(Theme.of(context).cardColor),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
            color: Theme.of(context).cardColor, // Set the border color to blue
            width: 2.3, // Set the border width (adjust as needed)
          ),
        ),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      ),
    );
  }
}
