import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watersec_mobileapp_front/View/components/languagedrop_button.dart';
import 'package:watersec_mobileapp_front/View/components/themeSwitch.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      // Update the app's theme
      Theme.of(context).brightness == Brightness.dark
          ? ThemeData.light()
          : ThemeData.dark();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 140,
            height: 140,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Général',
              style: TextStyles.MenuHeaderStyle(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.chartSimple,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Dashboard',
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.chartPie,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Analyses',
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/analyses');
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.solidBell,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Notifications',
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              'Gestion',
              style: TextStyles.MenuHeaderStyle(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.cog,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Paramètres',
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/parametres');
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.globe,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: MyDropdownMenu(),
            ),
          ),
          /*ThemeSwitch(
            currentThemeMode: _themeMode,
            onThemeChanged: _toggleTheme,
          ),*/
          SizedBox(
            height: 60,
          ),
          Container(
            padding: EdgeInsets.only(left: 70),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.signOut,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Logout',
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
