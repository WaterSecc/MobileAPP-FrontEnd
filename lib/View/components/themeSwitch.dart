import 'package:flutter/material.dart';

class ThemeSwitch extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final void Function(ThemeMode) onThemeChanged;

  const ThemeSwitch({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Switch(
        value: widget.currentThemeMode == ThemeMode.dark,
        onChanged: (value) {
          widget.onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
        },
        activeColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
