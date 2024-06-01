import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyAppBar extends StatelessWidget {
  final String page;
  const MyAppBar({required this.page});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: Builder(builder: (context) {
        return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(
              FontAwesomeIcons.bars,
              color: Theme.of(context).colorScheme.secondary,
            ));
      }),
      title: Row(
        children: [
          SizedBox(
            width: 190,
            child: Center(
              child: Text(
                page,
                style: TextStyles.appBarHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 14,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.solidBell,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(
            width: 3,
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Ink(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/azizatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
