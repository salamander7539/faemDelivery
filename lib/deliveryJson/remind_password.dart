import 'package:faem_delivery/auth_phone_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';

Future<dynamic> remindPassword() async {
  var body = json.encode({
    "device_id": deviceId,
    "phone": phone
  });
  var url = 'https://driver.apis.stage.faem.pro/api/v2/auth/remind/password';
  var response = await http.post(url, body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    ////////////////////////////////////////////////////////////
  } else {
    print("Error order with code ${response.statusCode}");
    print(response.body);
  }
  return response.statusCode;
}