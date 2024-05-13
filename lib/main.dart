import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/screens/analyses_screen.dart';
import 'package:watersec_mobileapp_front/screens/changepassword_screen.dart';
import 'package:watersec_mobileapp_front/screens/dashboard_screen.dart';
import 'package:watersec_mobileapp_front/screens/dashboardplus_screen.dart';
import 'package:watersec_mobileapp_front/screens/forgotpwd_screen.dart';
import 'package:watersec_mobileapp_front/screens/login_screen.dart';
import 'package:watersec_mobileapp_front/screens/notifications_screen.dart';
import 'package:watersec_mobileapp_front/screens/profile_screen.dart';
import 'package:watersec_mobileapp_front/screens/settings_screen.dart';
import 'package:watersec_mobileapp_front/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterSec',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(51, 132, 198, 1)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => Login(),
        '/forgotpwd': (context) => ForgotPwd(),
        '/dashboard': (context) => Dashboard(),
        '/profile': (context) => Profile(),
        '/changepwd': (context) => ChangePwd(),
        '/dashboardplus': (context) => DashPlus(),
        '/analyses': (context) => Analyses(),
        '/parametres': (context) => Settings(),
        '/notifications': (context) => Notifications(),
      },
    );
  }
}
