import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class MyDropdownMenu extends StatefulWidget {
  @override
  _MyDropdownMenuState createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  late String selectedLanguage = 'Français';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedLanguage,
        hint: Text(
          'Français',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.normal,
            fontSize: 18,
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
        onChanged: (String? newValue) {
          setState(() {
            selectedLanguage = newValue!;
          });
        },
        items: <DropdownMenuItem<String>>[
          DropdownMenuItem<String>(
            value: 'Français',
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  'FR',
                  height: 19,
                  width: 19,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Français',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'Anglais',
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  'US',
                  height: 19,
                  width: 19,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Anglais',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'Allemand',
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  'DE',
                  height: 19,
                  width: 19,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Allemand',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
