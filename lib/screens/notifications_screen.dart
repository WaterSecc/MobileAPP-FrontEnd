import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/constants/app_bar.dart';
import 'package:watersec_mobileapp_front/constants/drawer.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    late final String _page = 'Notifications';
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
          
        ),
      ),
    );
  }
}
