import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/constants/text_field.dart';

class MyPhoneNumberDDButton extends StatefulWidget {
  final List<String> phoneCodes;
  final String selectedPhoneCode;

  MyPhoneNumberDDButton({
    required this.phoneCodes,
    required this.selectedPhoneCode,
  });

  @override
  _MyPhoneNumberDDButtonState createState() => _MyPhoneNumberDDButtonState();
}

class _MyPhoneNumberDDButtonState extends State<MyPhoneNumberDDButton> {
  String selectedPhoneCode = '+ 216';
  List<String> phoneCodes = [
    '+ 20',
    '+ 33',
    '+ 49',
    '+ 30',
    '+ 39',
    '+ 961',
    '+ 218',
    '+ 212',
    '+ 31',
    '+ 966',
    '+ 41',
    '+ 216',
  ];

  @override
  void initState() {
    super.initState();
    selectedPhoneCode = widget.selectedPhoneCode;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedPhoneCode,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedPhoneCode = newValue;
            });
          }
        },
        items: phoneCodes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
