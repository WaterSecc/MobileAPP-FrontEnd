import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/languagedrop_button.dart';
import 'package:watersec_mobileapp_front/View/components/themeSwitch.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
              AppLocale.General.getString(context),
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
                AppLocale.Dashboard.getString(context),
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 27),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.chartPie,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocale.Analysis.getString(context),
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/analyses');
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 27),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.solidBell,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocale.Notifications.getString(context),
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/notifications');
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
            padding: EdgeInsets.only(left: 27),
            child: Text(
              AppLocale.Management.getString(context),
              style: TextStyles.MenuHeaderStyle(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 27),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.cog,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocale.Settings.getString(context),
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/parametres');
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 27),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.globe,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: MyDropdownMenu(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 27),
            child: ListTile(
              leading: const Icon(Icons.brightness_4),
              title: Text(
                AppLocale.AppTheme.getString(context),
                style: TextStyles.ListHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                // Get a reference to the ThemeProvider
                final themeProvider = ThemeProvider.controllerOf(context);

                // Toggle the theme
                themeProvider.nextTheme();
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 42),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.signOut,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocale.Logout.getString(context),
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
