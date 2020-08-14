import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

var respCode;

Future<AuthData> loadAuthData(String deviceId, String phone) async {
  AuthData authData;
  var jsonRequest = json.encode({
    "device_id": deviceId,
    "phone": phone
  });
  var url = 'https://driver.apis.stage.faem.pro/api/v2/auth/new';
  var response = await http.post(url, body: jsonRequest, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    authData = new AuthData.fromJson(jsonResponse);
    respCode = response.statusCode;
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return authData;
}


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
}