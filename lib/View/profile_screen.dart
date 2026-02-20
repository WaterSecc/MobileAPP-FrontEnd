import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/bottom_drawer.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';
import 'package:watersec_mobileapp_front/View/components/languageprofile.dart';
import 'package:watersec_mobileapp_front/colors.dart';

import 'package:watersec_mobileapp_front/ViewModel/editprofileViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/userInfoViewModel.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserInfoViewModel>().fetchUserInfo();
      context.read<EditProfileViewModel>().initUserData();
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      context.read<EditProfileViewModel>().setProfileImage(imageFile);
    }
  }

  // ✅ Full name = firstName + lastName from fetched data (fallback to controllers)
  String _fullName(UserInfoViewModel userInfoVM, EditProfileViewModel editVM) {
    final fnVm = userInfoVM.firstName.trim();
    final lnVm = userInfoVM.lastName.trim();

    final fn = fnVm.isNotEmpty ? fnVm : editVM.firstNameController.text.trim();
    final ln = lnVm.isNotEmpty ? lnVm : editVM.lastNameController.text.trim();

    final full = "$fn $ln".trim();
    return full.isEmpty ? "Fullname" : full;
  }

  // ✅ Avatar letter from the same fetched full name (so "Demo WaterSec" -> "D")
  String _avatarLetter(
      UserInfoViewModel userInfoVM, EditProfileViewModel editVM) {
    final full = _fullName(userInfoVM, editVM).trim();
    if (full.isEmpty || full == "Fullname") return "?";
    return full[0].toUpperCase();
  }

  // ✅ If there is a value -> show it, else show the label as placeholder
  String _valueOrLabel({required String value, required String label}) {
    final v = value.trim();
    return v.isEmpty ? label : v;
  }

  // ✅ Same logic but from controller
  String _controllerOrLabel({
    required TextEditingController controller,
    required String label,
  }) {
    final v = controller.text.trim();
    return v.isEmpty ? label : v;
  }

  Future<void> _openEditGeneralInfoSheet(
    BuildContext context,
    EditProfileViewModel editVM,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditSectionSheet(
        title: "General Info",
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hint: AppLocale.Name.getString(context),
                    controller: editVM.firstNameController,
                    onChanged: editVM.setFirstname,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyTextField(
                    hint: AppLocale.LastName.getString(context),
                    controller: editVM.lastNameController,
                    onChanged: editVM.setLastname,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            MyTextField(
              hint: AppLocale.Email.getString(context),
              controller: editVM.emailController,
              onChanged: editVM.setEmail,
            ),
            const SizedBox(height: 10),
            MyTextField(
              hint: AppLocale.Company.getString(context),
              controller: editVM.addressLineController,
              onChanged: editVM.setAddressLine,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: MyFilledButton(
                text: AppLocale.Save.getString(context),
                onPressed: () async {
                  final ok = await editVM.updateProfile();
                  if (context.mounted) Navigator.pop(context);

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ok
                            ? AppLocale.ChangedSuccessfully.getString(context)
                            : "Failed to update profile",
                      ),
                      backgroundColor: ok ? green : red,
                    ),
                  );

                  if (ok) {
                    context.read<UserInfoViewModel>().fetchUserInfo();
                    context.read<EditProfileViewModel>().initUserData();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditOtherSheet(
    BuildContext context,
    EditProfileViewModel editVM,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditSectionSheet(
        title: "Other",
        child: Column(
          children: [
            MyTextField(
              hint: "Employee Number",
              controller: editVM.cityController,
              onChanged: editVM.setCity,
            ),
            const SizedBox(height: 10),
            MyTextField(
              hint: AppLocale.PhoneNumber.getString(context),
              controller: editVM.phoneNumberController,
              onChanged: editVM.setPhone,
            ),
            const SizedBox(height: 10),
            MyTextField(
              hint: "Position",
              controller: editVM.countryController,
              onChanged: editVM.setCountry,
            ),
            const SizedBox(height: 10),

            // ✅ IMPORTANT: no Expanded in bottom sheet (this fixes the popup)
            MyLanguageDropdownMenu(
              onLanguageChanged: (selectedLanguage) {
                editVM.setLanguage(selectedLanguage);
              },
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: MyFilledButton(
                text: AppLocale.Save.getString(context),
                onPressed: () async {
                  final ok = await editVM.updateProfile();
                  if (context.mounted) Navigator.pop(context);

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ok
                            ? AppLocale.ChangedSuccessfully.getString(context)
                            : "Failed to update profile",
                      ),
                      backgroundColor: ok ? green : red,
                    ),
                  );

                  if (ok) {
                    context.read<UserInfoViewModel>().fetchUserInfo();
                    context.read<EditProfileViewModel>().initUserData();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfoVM = context.watch<UserInfoViewModel>();
    final editVM = context.watch<EditProfileViewModel>();
    final isLoading = userInfoVM.id == 0 || editVM.isLoading;

    final w = MediaQuery.of(context).size.width;
    final avatarSize = (w * 0.26).clamp(88.0, 120.0);

    // ✅ derived display name + letter from fetched data
    final fullNameDisplay = _fullName(userInfoVM, editVM);
    final avatarLetter = _avatarLetter(userInfoVM, editVM);

    // ✅ DISPLAY VALUES FROM CONTROLLERS (they are populated in initUserData)
    final nameDisplay = _controllerOrLabel(
      controller: editVM.firstNameController,
      label: AppLocale.Name.getString(context),
    );
    final lastNameDisplay = _controllerOrLabel(
      controller: editVM.lastNameController,
      label: AppLocale.LastName.getString(context),
    );
    final emailDisplay = _controllerOrLabel(
      controller: editVM.emailController,
      label: AppLocale.Email.getString(context),
    );
    final companyDisplay = _controllerOrLabel(
      controller: editVM.addressLineController,
      label: AppLocale.Company.getString(context),
    );

    final employeeDisplay = _controllerOrLabel(
      controller: editVM.cityController,
      label: "Employee Number",
    );
    final phoneDisplay = _controllerOrLabel(
      controller: editVM.phoneNumberController,
      label: AppLocale.PhoneNumber.getString(context),
    );
    final positionDisplay = _controllerOrLabel(
      controller: editVM.countryController,
      label: "Position",
    );

    // ✅ language display: if your editVM has selectedLanguage, show it, else show label
    String languageDisplay = "Language";
    try {
      final dynamic any = editVM;
      final dynamic lang = any.selectedLanguage; // if exists
      if (lang is String && lang.trim().isNotEmpty) {
        languageDisplay = lang.trim();
      }
    } catch (_) {
      // keep "Language"
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(
          title: AppLocale.Profile.getString(context),
        ),
      ),
      endDrawer: ProfileEndDrawer(
        onProfileTap: () => Navigator.pushReplacementNamed(context, '/profile'),
        onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      bottomNavigationBar: const MyBottomNav(
        currentIndex: 0,
        noSelection: true,
      ),
      body: Skeletonizer(
        enabled: isLoading,
        ignoreContainers: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Header row (avatar + fullname) =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: newBlue,
                        ),
                        child: userInfoVM.avatarUrl.isEmpty
                            ? Center(
                                child: Text(
                                  avatarLetter, // ✅ dynamic letter
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              )
                            : ClipOval(
                                child: Image.network(
                                  userInfoVM.avatarUrl,
                                  width: avatarSize,
                                  height: avatarSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        avatarLetter, // ✅ same dynamic letter
                                        style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                          color: white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),

                      // camera button (unchanged logic)
                      Positioned(
                        right: -6,
                        bottom: -6,
                        child: InkWell(
                          onTap: () => pickImage(ImageSource.gallery),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: black,
                              ),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.cameraRetro,
                              size: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      fullNameDisplay, // ✅ dynamic full name
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ===== General Info card =====
              _SectionCard(
                title: "General Info",
                rows: [
                  _InfoRow(
                    label: AppLocale.Name.getString(context),
                    value: nameDisplay,
                  ),
                  _InfoRow(
                    label: AppLocale.LastName.getString(context),
                    value: lastNameDisplay,
                  ),
                  _InfoRow(
                    label: AppLocale.Email.getString(context),
                    value: emailDisplay,
                  ),
                  _InfoRow(
                    label: AppLocale.Company.getString(context),
                    value: companyDisplay,
                  ),
                ],
                buttonText: "Edit",
                onEdit: () => _openEditGeneralInfoSheet(context, editVM),
              ),

              const SizedBox(height: 18),

              // ===== Other card =====
              _SectionCard(
                title: "Other",
                rows: [
                  _InfoRow(label: "Employee Number", value: employeeDisplay),
                  _InfoRow(label: "Telephone number", value: phoneDisplay),
                  _InfoRow(label: "Position", value: positionDisplay),
                  _InfoRow(label: "Language", value: languageDisplay),
                ],
                buttonText: "Edit",
                onEdit: () => _openEditOtherSheet(context, editVM),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;
  final String buttonText;
  final VoidCallback onEdit;

  const _SectionCard({
    required this.title,
    required this.rows,
    required this.buttonText,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(rows.length, (i) {
            final r = rows[i];
            final isLast = i == rows.length - 1;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r.value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: newBlue.withOpacity(0.2),
                  ),
                  if (!isLast) const SizedBox(height: 12),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 110,
              height: 36,
              child: MyFilledButton(
                text: buttonText,
                onPressed: onEdit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditSectionSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _EditSectionSheet({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                child,
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
