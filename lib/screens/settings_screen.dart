import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/constants/app_bar.dart';
import 'package:watersec_mobileapp_front/constants/drawer.dart';
import 'package:watersec_mobileapp_front/constants/text_button.dart';
import 'package:watersec_mobileapp_front/screens/threshold_screen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    late final String _page = 'Paramètres';
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        drawer: MyDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MyAppBar(page: _page),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                  margin: EdgeInsets.only(left: 110),
                  child: MyTextBtn(text: 'Seuil Global: 5000 Litres', onPressed: () {
                    showModalBottomSheet<void>(context: context,  builder: (BuildContext context) { return ThresholdScreen(); });
                  },))
            ],
          ),
        ),
      ),
    );
  }
}
