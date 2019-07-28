class JsonUser {
  String email;
  String authenticationToken;
  JsonUser({
    this.email,
    this.authenticationToken,
  });
  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    Map json = parsedJson['user'];
    return JsonUser(
      email: json['email'],
      authenticationToken: json['authentication_token'],
    );
  }
}