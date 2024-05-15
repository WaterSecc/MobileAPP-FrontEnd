import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyAppBar extends StatelessWidget {
  final String page;
  const MyAppBar({required this.page});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      title: Row(
        children: [
          SizedBox(
            width: 190,
            child: Center(
              child: Text(
                page,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                  color: Color.fromRGBO(0, 0, 0, 1),
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
            icon: Icon(FontAwesomeIcons.solidBell),
          ),
          SizedBox(
            width: 3,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
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
