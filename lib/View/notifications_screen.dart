import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';

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
      decoration:  BoxDecoration(color: Theme.of(context).colorScheme.background,),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
