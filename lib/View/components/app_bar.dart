import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/View/components/profile_dropdownmenu.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';
import 'package:flutter/services.dart';

class MyAppBar extends StatelessWidget {
  final String? title;
  final bool isHome;

  const MyAppBar({
    Key? key,
    this.title,
    this.isHome = false,
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final bgColor = isHome
        ? newBlue // 👈 HOME color
        : Theme.of(context).colorScheme.background;

    final contentColor = isHome
        ? Colors.white // 👈 HOME text/icons
        : Theme.of(context).colorScheme.secondary;

    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      automaticallyImplyLeading: false,

      // ensures status bar icons are correct (iOS + Android)
      systemOverlayStyle:
          isHome ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,

      // ───────────────────────────────────
      // LEFT SIDE
      // ───────────────────────────────────
      leadingWidth: isHome ? 190 : null,
      leading: isHome
          ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Image.asset(
                'assets/images/WhiteNewLogoHorizontal.png',
                fit: BoxFit.contain, // optional: force white logo
              ),
            )
          : null,

      // ───────────────────────────────────
      // TITLE (non-home only)
      // ───────────────────────────────────
      title: !isHome && title != null
          ? Text(
              title!,
              style: TextStyles.appBarHeaderStyle(contentColor),
            )
          : null,

      centerTitle: false,

      // ───────────────────────────────────
      // RIGHT SIDE
      // ───────────────────────────────────
      actions: [
        Builder(
          builder: (ctx) => ProfileDropdownMenu(
            //final Color iconColor; // 👈 pass color
            onTap: () => Scaffold.of(ctx).openEndDrawer(),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
