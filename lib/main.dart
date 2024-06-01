import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/analyses_screen.dart';
import 'package:watersec_mobileapp_front/View/changepassword_screen.dart';
import 'package:watersec_mobileapp_front/View/dashboardplus_screen.dart';
import 'package:watersec_mobileapp_front/View/forgotpwd_screen.dart';
import 'package:watersec_mobileapp_front/View/login_screen.dart';
import 'package:watersec_mobileapp_front/View/notifications_screen.dart';
import 'package:watersec_mobileapp_front/View/splash_screen.dart';
import 'package:watersec_mobileapp_front/View/dashboard_screen.dart';
import 'package:watersec_mobileapp_front/View/profile_screen.dart';
import 'package:watersec_mobileapp_front/View/settings_screen.dart';
import 'package:watersec_mobileapp_front/theme/appThemes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final FlutterLocalization localization = FlutterLocalization.instance;

class _MyAppState extends State<MyApp> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('fr', AppLocale.FR),
        const MapLocale('de', AppLocale.DE)
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    print(_currentLocale);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
            id: 'light',
            data: MyAppThemes.lightTheme,
            description: 'Light Theme'),
        AppTheme(
            id: 'dark', data: MyAppThemes.darkTheme, description: 'Dark Theme'),
      ],
      child: ThemeConsumer(
        child: Builder(builder: (themeContext) {
          return MaterialApp(
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,
            title: 'WaterSec',
            theme: ThemeProvider.themeOf(themeContext).data,
            themeMode: ThemeMode.system,
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const Login(),
              '/forgotpwd': (context) => const ForgotPwd(),
              '/dashboard': (context) => const Dashboard(),
              '/profile': (context) => const Profile(),
              '/changepwd': (context) => const ChangePwd(),
              '/dashboardplus': (context) => const DashPlus(),
              '/analyses': (context) => const Analyses(),
              '/parametres': (context) => const Settings(),
              '/notifications': (context) => const Notifications(),
            },
          );
        }),
      ),
    );
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}
