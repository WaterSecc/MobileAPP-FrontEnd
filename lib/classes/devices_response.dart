class DevicesResponse {
  final List<String> devicelist;

  DevicesResponse({
    required this.devicelist,
  });

  factory DevicesResponse.fromJson(List<dynamic> json) {
    return DevicesResponse(
      devicelist: List<String>.from(json),
    );
  }
}
