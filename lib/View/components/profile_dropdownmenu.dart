import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/ViewModel/userInfoViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class ProfileDropdownMenu extends StatefulWidget {
  /// Optional: if you want to control what happens on tap from outside.
  /// If null, it will try to open the Scaffold endDrawer.
  final VoidCallback? onTap;

  const ProfileDropdownMenu({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<ProfileDropdownMenu> createState() => _ProfileDropdownMenuState();
}

class _ProfileDropdownMenuState extends State<ProfileDropdownMenu> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserInfoViewModel>().fetchUserInfo();
    });
  }

  void _handleTap(BuildContext context) {
    if (widget.onTap != null) {
      widget.onTap!.call();
      return;
    }

    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState != null && scaffoldState.hasEndDrawer) {
      scaffoldState.openEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfoVM = context.watch<UserInfoViewModel>();

    final String avatarLetter = userInfoVM.firstName.trim().isNotEmpty
        ? userInfoVM.firstName.trim()[0].toUpperCase()
        : '?';

    const double size = 40; // radius 18 * 2

    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: newBlue, // ✅ same as profile avatar
        ),
        child: userInfoVM.avatarUrl.isEmpty
            ? Center(
                child: Text(
                  avatarLetter,
                  style: TextStyle(
                    color: white, // ✅ always white (fix)
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            : ClipOval(
                child: Image.network(
                  userInfoVM.avatarUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // ✅ fallback to letter if image fails (same behavior as profile)
                    return Center(
                      child: Text(
                        avatarLetter,
                        style: TextStyle(
                          color: white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
