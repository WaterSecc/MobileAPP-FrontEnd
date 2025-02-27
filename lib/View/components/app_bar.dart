import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/components/profile_dropdownmenu.dart';
import 'package:watersec_mobileapp_front/ViewModel/notificationViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyAppBar extends StatelessWidget {
  final String page;
  const MyAppBar({required this.page});

  @override
  Widget build(BuildContext context) {
    final notificationViewModel = Provider.of<NotificationViewModel>(context);

    // Retrieve unread count from NotificationViewModel
    final int unreadCount = notificationViewModel.unreadCount;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(
            FontAwesomeIcons.bars,
            color: Theme.of(context).colorScheme.secondary,
          ),
        );
      }),
      title: Row(
        children: [
          Flexible(
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
              width: MediaQuery.of(context).size.width *
                  0.05), // Responsive spacing
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Navigate to notifications screen
                  Navigator.pushNamed(context, '/notifications');
                },
                icon: Icon(
                  FontAwesomeIcons.solidBell,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: red,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: TextStyle(
                        color: white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
              width:
                  MediaQuery.of(context).size.width * 0.01), // Adjust spacing
          // Profile picture with a dropdown menu
          ProfileDropdownMenu(
            onProfileTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}
