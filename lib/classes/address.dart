class Address {
  final String addressLine;
  final String zipCode;
  final String country;
  final String city;

  Address({
    required this.addressLine,
    required this.zipCode,
    required this.country,
    required this.city,
  });
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressLine: json['address_line'],
      zipCode: json['zip_code'],
      country: json['country'],
      city: json['city'],
    );
  }
}
