import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyTxtBtnNotOutlined extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const MyTxtBtnNotOutlined(
      {super.key, required this.text, required this.onPressed});

  @override
  State<MyTxtBtnNotOutlined> createState() => _MyTxtBtnNotOutlinedState();
}

class _MyTxtBtnNotOutlinedState extends State<MyTxtBtnNotOutlined> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: Text(
        widget.text,
        style: TextStyles.txtBtnNOStyle(blue),
      ),
    );
  }
}
