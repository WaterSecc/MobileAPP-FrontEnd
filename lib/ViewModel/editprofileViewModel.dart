import 'dart:io';

import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/Model/editprofile_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/userInfoViewModel.dart';

class EditProfileViewModel extends ChangeNotifier {
  final _editprofileService = EditProfileService();
  final _loginViewModel = LoginViewModel();
  final _userinfoViewModel = UserInfoViewModel();

  // TextEditingControllers for form fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressLineController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  File? _profileImage;
File? get profileImage => _profileImage;

   // Add property for selected language
  String _selectedLanguage = 'en'; // Default to English, update as needed
  String get selectedLanguage => _selectedLanguage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error message handling
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Initialize the user data and populate controllers
  Future<void> initUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch the user info from UserInfoViewModel
      await _userinfoViewModel.fetchUserInfo();

      // Populate the controllers with the fetched data
      firstNameController.text = _userinfoViewModel.firstName;
      lastNameController.text = _userinfoViewModel.lastName;
      emailController.text = _userinfoViewModel.email;
      phoneNumberController.text = _userinfoViewModel.phoneNumber;
      addressLineController.text = _userinfoViewModel.address.addressLine;
      countryController.text = _userinfoViewModel.address.country;
      cityController.text = _userinfoViewModel.address.city;
      zipCodeController.text = _userinfoViewModel.address.zipCode;
      _selectedLanguage = _userinfoViewModel.locale; // Fetch the current language

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error fetching user info: $e';
      notifyListeners();
    }
  }
  // Setter for language
  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  // Setters for the fields to be updated
  void setFirstname(String firstname) {
    firstNameController.text = firstname;
    notifyListeners();
  }

  void setLastname(String lastname) {
    lastNameController.text = lastname;
    notifyListeners();
  }

  void setEmail(String email) {
    emailController.text = email;
    notifyListeners();
  }

  void setPhone(String phone) {
    phoneNumberController.text = phone;
    notifyListeners();
  }

  void setAddressLine(String addressLine) {
    addressLineController.text = addressLine;
    notifyListeners();
  }

  void setCountry(String country) {
    countryController.text = country;
    notifyListeners();
  }

  void setCity(String city) {
    cityController.text = city;
    notifyListeners();
  }

  void setZipCode(String zipCode) {
    zipCodeController.text = zipCode;
    notifyListeners();
  }

  void setProfileImage(File image) {
  _profileImage = image;
  notifyListeners();
}

  // Update profile function
  Future<bool> updateProfile() async {
  try {
    final accessToken = await _loginViewModel.getAccessToken();
    if (accessToken != null) {
      // Construct headers with the access token
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      // Call the edit profile function
      final isSuccess = await _editprofileService.editProfile(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        phoneNumberController.text,
        addressLineController.text,
        countryController.text,
        cityController.text,
        zipCodeController.text,
        _selectedLanguage, // Pass selected language
        headers: headers,  // Pass headers with access token
        profileImage: _profileImage, // Optional parameter
      );

      if (isSuccess) {
        _errorMessage = 'Profile updated successfully!';
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Profile update failed.';
        notifyListeners();
        return false;
      }
    } else {
      _errorMessage = 'Failed to get access token.';
      notifyListeners();
      return false;
    }
  } catch (e) {
    _errorMessage = 'Error updating profile: $e';
    notifyListeners();
    return false;
  }
}



  @override
  void dispose() {
    // Dispose controllers when no longer needed
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    addressLineController.dispose();
    countryController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }
}
