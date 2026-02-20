import 'package:watersec_mobileapp_front/classes/address.dart';

class UserResponse {
  final num id;
  final String firstName;
  final String lastName;
  final String email;
  final String name;
  final String contactEmail;
  final String contactPhone;
  final num categoryId;
  final String scope;
  final String fcmToken;
  final String locale;
  final String displayName;
  final String phoneNumber;
  final String avatarUrl;
  final Address? address;

  UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.name,
    required this.contactEmail,
    required this.contactPhone,
    required this.categoryId,
    required this.scope,
    required this.fcmToken,
    required this.locale,
    required this.displayName,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.address,
  });
}
