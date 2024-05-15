import 'package:flutter/material.dart';
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
