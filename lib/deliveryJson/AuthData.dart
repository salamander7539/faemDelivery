import 'dart:convert';

class AuthData {
  int code;
  String message;

  // ignore: non_constant_identifier_names
  int next_request_time;

  AuthData({
    this.code,
    this.message,
    // ignore: non_constant_identifier_names
    this.next_request_time
  });

  factory AuthData.fromJson(Map<String, dynamic> parsedJson){
    return AuthData(
        code: parsedJson['code'],
        message: parsedJson['message'],
        next_request_time: parsedJson['next_request_time']
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "next_request_time": next_request_time,
  };
}
