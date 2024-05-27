import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:watersec_mobileapp_front/View/login_screen.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Login(),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            white,
            Theme.of(context).cardColor,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            SizedBox(
              height: 110,
              width: 110,
              child: Image(
                image: AssetImage('assets/images/waterseclogo.png'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'WaterSec',
              style: TextStyle(
                color: gray,
                fontSize: 35,
                fontFamily: 'Monda',
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
