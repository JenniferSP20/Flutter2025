class Auth {
  final String username;
  final String password;
  final String request_token;

  Auth({
    required this.username,
    required this.password,
    required this.request_token,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      username: json['username'],
      password: json['password'],
      request_token: json['request_token'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'request_token': request_token,
    };
  }
}
