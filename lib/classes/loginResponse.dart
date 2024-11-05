class LoginResponse {
  final bool isSuccess;
  final String? accessToken;
  final String? errorMessage;

  LoginResponse({
    required this.isSuccess,
    this.accessToken,
    this.errorMessage,
  });
}