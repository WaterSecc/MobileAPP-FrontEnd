import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/userInfoViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

// Create a global RouteObserver (add this to main.dart and pass it to MaterialApp)
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class ProfileDropdownMenu extends StatefulWidget {
  final VoidCallback onProfileTap;

  const ProfileDropdownMenu({
    Key? key,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  State<ProfileDropdownMenu> createState() => _ProfileDropdownMenuState();
}

class _ProfileDropdownMenuState extends State<ProfileDropdownMenu> with RouteAware {
  GlobalKey actionKey = GlobalKey();
  bool isDropdownOpened = false;
  OverlayEntry? floatingDropdown;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserInfoViewModel>().fetchUserInfo();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);

  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    // Called when navigating to a new page
    if (isDropdownOpened) {
      toggleDropdown();
    }
  }

  void toggleDropdown() {
    if (isDropdownOpened) {
      floatingDropdown?.remove();
      floatingDropdown = null;
    } else {
      floatingDropdown = _createFloatingDropdown();
      Overlay.of(context).insert(floatingDropdown!);
    }
    setState(() {
      isDropdownOpened = !isDropdownOpened;
    });
  }

  OverlayEntry _createFloatingDropdown() {
    RenderBox renderBox = actionKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    double dropdownTop = offset.dy + size.height + 8;
    double screenHeight = MediaQuery.of(context).size.height;
    if (dropdownTop + 100 > screenHeight) {
      dropdownTop = screenHeight - 112;
    }

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (isDropdownOpened) {
            toggleDropdown(); // Close dropdown on outside tap
          }
        },
        child: Stack(
          children: [
            Positioned(
              width: size.width * 3.5,
              top: dropdownTop,
              left: offset.dx - 73,
              child: Material(
                elevation: 8.0,
                color: Colors.transparent,
                child: Container(
                  height: 95,
                  decoration: BoxDecoration(
                    color: blue.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          widget.onProfileTap();
                          toggleDropdown();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.solidUser, color: white, size: 13),
                              const SizedBox(width: 3),
                              Text(
                                AppLocale.Profile.getString(context),
                                style: TextStyles.txtBtnNOStyle(white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
                          await loginViewModel.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                          toggleDropdown();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.signOut, color: white, size: 13),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  AppLocale.Logout.getString(context),
                                  style: TextStyles.txtBtnNOStyle(white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfoViewModel = Provider.of<UserInfoViewModel>(context);
    String firstLetter = userInfoViewModel.firstName.isNotEmpty
        ? userInfoViewModel.firstName[0]
        : '?';

    return GestureDetector(
      key: actionKey,
      onTap: toggleDropdown,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: green,
        backgroundImage: userInfoViewModel.avatarUrl.isNotEmpty
            ? NetworkImage(userInfoViewModel.avatarUrl)
            : null,
        child: userInfoViewModel.avatarUrl.isEmpty
            ? Text(
                firstLetter,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}
