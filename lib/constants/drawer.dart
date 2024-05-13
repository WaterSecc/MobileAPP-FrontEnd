import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watersec_mobileapp_front/constants/languagedrop_button.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
            child: const Text(
              'Général',
              style: TextStyle(
                fontFamily: 'Monda',
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: Color.fromRGBO(90, 90, 90, 1),
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
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              title: Text(
                'Dashboard',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color.fromRGBO(0, 0, 0, 1),
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
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              title: Text(
                'Analyses',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color.fromRGBO(0, 0, 0, 1),
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
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              title: Text(
                'Notifications',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: const Text(
              'Gestion',
              style: TextStyle(
                fontFamily: 'Monda',
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: Color.fromRGBO(90, 90, 90, 1),
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
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              title: Text(
                'Paramètres',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color.fromRGBO(0, 0, 0, 1),
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
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              title: MyDropdownMenu(),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          Container(
            padding: EdgeInsets.only(left: 70),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.signOut,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
