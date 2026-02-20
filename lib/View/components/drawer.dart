import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/languagedrop_button.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class ProfileEndDrawer extends StatelessWidget {
  const ProfileEndDrawer({
    Key? key,
    this.onProfileTap,
    this.onLogout,
  }) : super(key: key);

  final VoidCallback? onProfileTap;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Header =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: secondary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.chevron_right,
                      size: 32,
                      color: secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 54),

              // ===== Card 1: Profile =====
              _Card(
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    onProfileTap?.call();
                  },
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black.withOpacity(0.06),
                    child: Icon(Icons.person, color: secondary),
                  ),
                  title: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: secondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: secondary.withOpacity(0.85),
                  ),
                ),
              ),

              const SizedBox(height: 58),

              // ===== Card 2: Settings & Privacy + Language + Theme =====
              _Card(
                child: Column(
                  children: [
                    _rowDividerTile(
                      context,
                      icon: FontAwesomeIcons.gear,
                      title: "Settings and Privacy",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/changepwd');
                      },
                    ),
                    Divider(height: 1, color: Colors.black.withOpacity(0.08)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ListTile(
                        leading: Icon(Icons.language, color: secondary),
                        title: Text(
                          "English",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: secondary,
                          ),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_down),
                        // If you want the dropdown inline, replace the title with your widget:
                        // title: MyDropdownMenu(),
                        onTap: () {
                          // Optional: open a bottom sheet for language
                          // or keep your existing dropdown widget in title.
                        },
                      ),
                    ),
                    Divider(height: 1, color: Colors.black.withOpacity(0.08)),
                    _rowDividerTile(
                      context,
                      icon: Icons.brightness_6_outlined,
                      title: "Theme",
                      onTap: () {
                        final controller = ThemeProvider.controllerOf(context);
                        controller.nextTheme();
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ===== Logout Button =====
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: newBlue,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onLogout?.call();
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowDividerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final secondary = Theme.of(context).colorScheme.secondary;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: secondary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: secondary,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
