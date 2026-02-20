import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/View/components/watermeter_selection_popup.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/notificationViewModel.dart';

class MyBottomNav extends StatelessWidget {
  const MyBottomNav({
    super.key,
    required this.currentIndex,
    this.noSelection = false,
  });

  final int currentIndex;
  final bool noSelection;

  @override
  Widget build(BuildContext context) {
    final notificationVM = context.watch<NotificationViewModel>();
    final int unreadCount = notificationVM.unreadCount;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: noSelection ? 0 : currentIndex,
      selectedItemColor: noSelection ? gray : newBlue,
      unselectedItemColor: gray,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      onTap: (index) async {
        // ✅ only block re-tapping the same tab when noSelection is false
        if (!noSelection && index == currentIndex) return;

        if (index == 2) {
          final vm = Provider.of<WaterMetersViewModel>(context, listen: false);
          await vm.fetchWaterMeters();
          showDialog(
            context: context,
            builder: (_) => WaterMeterSelectionPopup(onMetersSelected: (_) {}),
          );
          return;
        }

        final routes = [
          '/dashboard',
          '/analyses',
          '',
          '/notifications',
          '/parametres',
        ];

        if (routes[index].isNotEmpty) {
          Navigator.pushReplacementNamed(context, routes[index]);
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.chartSimple),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.chartPie),
          label: 'Analysis',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.water_drop),
          label: 'Meters',
        ),

        // ✅ Alerts with badge
        BottomNavigationBarItem(
          icon: _BellWithBadge(unreadCount: unreadCount),
          label: 'Alerts',
        ),

        const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.cog),
          label: 'Settings',
        ),
      ],
    );
  }
}

class _BellWithBadge extends StatelessWidget {
  final int unreadCount;

  const _BellWithBadge({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(FontAwesomeIcons.solidBell),
        if (unreadCount > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.circular(999),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
