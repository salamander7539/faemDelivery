import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'AuthData.dart';

var respCode, respMessage, remindMessage;

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
    print(response.body);
    authData = new AuthData.fromJson(jsonResponse);
    respCode = authData.code;
    respMessage = authData.message;
    if (respMessage == 'Введите пароль из смс сообщения') {
      remindMessage = null;
    } else if (respMessage == 'Введите пароль') {
      remindMessage = 'Забыли пароль?';
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.statusCode);
  return authData;
}
