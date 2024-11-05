import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyLanguageDropdownMenu extends StatefulWidget {
  final Function(String) onLanguageChanged;

  const MyLanguageDropdownMenu({required this.onLanguageChanged});

  @override
  _MyLanguageDropdownMenuState createState() => _MyLanguageDropdownMenuState();
}

class _MyLanguageDropdownMenuState extends State<MyLanguageDropdownMenu> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _currentLocale,
        hint: Text(
          _currentLocale,
          style: TextStyles.ListHeaderStyle(
            Theme.of(context).colorScheme.secondary,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _currentLocale = value!;
            widget.onLanguageChanged(value);
          });
        },
        items: <DropdownMenuItem<String>>[
          DropdownMenuItem<String>(
            value: 'en',
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
                  'English',
                  style: TextStyles.ListHeaderStyle(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'fr',
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
                  'French',
                  style: TextStyles.ListHeaderStyle(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'de',
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
                  'German',
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
