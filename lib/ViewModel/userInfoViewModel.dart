import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/Model/userInfo_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/classes/address.dart';

class UserInfoViewModel extends ChangeNotifier {
  final _userinfoService = UserInfoService();
  final _loginViewModel = LoginViewModel();

  int _id = 0;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _name = '';
  String _contactEmail = '';
  String _contactPhone = '';
  int _categoryId = 0; 
  String _scope = '';
  String _fcmToken = '';
  String _locale = '';
  String _displayName = ''; 
  String _phoneNumber = '';
  String _avatarUrl = '';
  Address _address = Address(
    addressLine: '',
    zipCode: '',
    country: '',
    city: '',
  );

  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get name => _name;
  String get contactEmail => _contactEmail;
  String get contactPhone => _contactPhone;
  int get categoryId => _categoryId;
  String get scope => _scope;
  String get fcmToken => _fcmToken;
  String get locale => _locale;
  String get displayName => _displayName;
  String get phoneNumber => _phoneNumber;
  String get avatarUrl => _avatarUrl;
  Address get address =>
      _address ??
      Address(
        addressLine: '',
        zipCode: '',
        country: '',
        city: '',
      );

  Future<void> fetchUserInfo() async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();
      print(accessToken);
      if (accessToken != null) {
        final userResponse = await _userinfoService.getUserInfo(accessToken);
        _id = userResponse.id.toInt();
        _firstName = userResponse.firstName;
        _lastName = userResponse.lastName;
        _email = userResponse.email;
        _name = userResponse.name;
        _contactEmail = userResponse.contactEmail;
        _contactPhone = userResponse.contactPhone;
        _categoryId = userResponse.categoryId.toInt();
        _scope = userResponse.scope;
        _fcmToken = userResponse.fcmToken;
        _locale = userResponse.locale;
        _displayName = userResponse.displayName;
        _phoneNumber = userResponse.phoneNumber;
        _avatarUrl = userResponse.avatarUrl;
        _address = userResponse.address ??
            Address(
              addressLine: '',
              zipCode: '',
              country: '',
              city: '',
            );
        print('user response: $userResponse');
        print('address: $_address');
        notifyListeners();
      } else {
        // Handle the case when the access token is not available
        print('Access token is not available');
      }
    } catch (e) {
      // Handle the error case
      print('Error fetching user: $e');
    }
  }
}
