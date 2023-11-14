
class AuthToken {
  final String? token;
  AuthToken({
    this.token
  });
  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
        token:json['token'] as String?,
    );
  }
}