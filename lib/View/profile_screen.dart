import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/languageprofile.dart';
import 'package:watersec_mobileapp_front/View/components/textBtnNotOutlined.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';
import 'package:watersec_mobileapp_front/ViewModel/editprofileViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/userInfoViewModel.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserInfoViewModel>().fetchUserInfo();
      context.read<EditProfileViewModel>().initUserData();
    });
  }

  Future<void> requestPermissions() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? pickedFile = await _picker.pickImage(source: source);

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    context.read<EditProfileViewModel>().setProfileImage(imageFile);
  }
}

  @override
  Widget build(BuildContext context) {
    final userInfoViewModel = context.watch<UserInfoViewModel>();
    final editProfileViewModel = context.watch<EditProfileViewModel>();
    final isLoading =
        userInfoViewModel.id == 0 || editProfileViewModel.isLoading;
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.4; // Adjust size dynamically
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: const MyDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(page: AppLocale.Profile.getString(context)),
      ),
      body: Skeletonizer(
        enabled: isLoading,
        ignoreContainers: true,
        child: SingleChildScrollView( 
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // User Icon
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: green,
                        ),
                        child: userInfoViewModel.avatarUrl.isEmpty
                            ? Center(
                                child: Text(
                                  userInfoViewModel.firstName.isNotEmpty
                                      ? userInfoViewModel.firstName[0]
                                          .toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              )
                            : ClipOval(
                                child: Image.network(
                                  userInfoViewModel.avatarUrl,
                                  width: avatarSize,
                                  height: avatarSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        userInfoViewModel.firstName.isNotEmpty
                                            ? userInfoViewModel.firstName[0]
                                                .toUpperCase()
                                            : '?',
                                        style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            pickImage(ImageSource.gallery);
                          },
                          icon: Icon(
                            FontAwesomeIcons.cameraRetro,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Form fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // Name Fields Row
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              hint: AppLocale.Name.getString(context),
                              controller:
                                  editProfileViewModel.firstNameController,
                              onChanged: editProfileViewModel.setFirstname,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: MyTextField(
                              hint: AppLocale.LastName.getString(context),
                              controller:
                                  editProfileViewModel.lastNameController,
                              onChanged: editProfileViewModel.setLastname,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Email Field
                      MyTextField(
                        hint: AppLocale.Email.getString(context),
                        controller: editProfileViewModel.emailController,
                        onChanged: editProfileViewModel.setEmail,
                      ),
                      const SizedBox(height: 10),
                      // Address Field
                      MyTextField(
                        hint: AppLocale.Company.getString(context),
                        controller: editProfileViewModel.addressLineController,
                        onChanged: editProfileViewModel.setAddressLine,
                      ),
                      const SizedBox(height: 10),
                      // Country and Employees Field Row
                      Row(
                        children: [
                          Expanded(
                            child: MyLanguageDropdownMenu(
                              onLanguageChanged: (selectedLanguage) {
                                editProfileViewModel
                                    .setLanguage(selectedLanguage);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: MyTextField(
                              hint: AppLocale.Employees.getString(context),
                              controller: editProfileViewModel.cityController,
                              onChanged: editProfileViewModel.setCity,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Phone Number Field
                      MyTextField(
                        hint: AppLocale.PhoneNumber.getString(context),
                        controller: editProfileViewModel.phoneNumberController,
                        onChanged: editProfileViewModel.setPhone,
                      ),
                      const SizedBox(height: 10),
                      // Number of Employees Field
                      MyTextField(
                        hint: AppLocale.Employees.getString(context),
                        controller: editProfileViewModel.countryController,
                        onChanged: editProfileViewModel.setCountry,
                      ),
                      const SizedBox(height: 20),
                      // Save Button
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: MyFilledButton(
                          text: AppLocale.Save.getString(context),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              final isProfileUpdated =
                                  await editProfileViewModel.updateProfile();
                              if (isProfileUpdated) {
                                Navigator.popAndPushNamed(context, '/profile');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocale.ChangedSuccessfully.getString(
                                          context),
                                    ),
                                    backgroundColor: green,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      // Change Password Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: MyTxtBtnNotOutlined(
                          onPressed: () {
                            Navigator.pushNamed(context, '/changepwd');
                          },
                          text: AppLocale.ChangePwd.getString(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
