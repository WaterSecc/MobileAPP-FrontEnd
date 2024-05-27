import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

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
          selectedLanguage,
          style: TextStyles.ListHeaderStyle(
            Theme.of(context).colorScheme.secondary,
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
                  style: TextStyles.ListHeaderStyle(
                    Theme.of(context).colorScheme.secondary,
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
                  style: TextStyles.ListHeaderStyle(
                    Theme.of(context).colorScheme.secondary,
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
                  style: TextStyles.ListHeaderStyle(
                    Theme.of(context).colorScheme.secondary,
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
