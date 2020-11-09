import 'package:faem_delivery/deliveryJson/deliver_verification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

String newToken, clientCode, newRefToken;
var updateResponse, updateCode;

Future<dynamic> updateRefreshToken(String refresh) async {
  sharedPreferences = await SharedPreferences.getInstance();
  var jsonBody = json.encode({
    "refresh": refresh,
  });
  const url = "https://driver.apis.stage.faem.pro/api/v2/auth/refresh";
  var response = await http.post(url, body: jsonBody, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    updateResponse = json.decode(response.body);
    // print(response.body);
    updateCode = updateResponse['code'];
    newToken = updateResponse['token'];
    await sharedPreferences.setString('token', updateResponse['token']);
    await sharedPreferences.setString('refToken', updateResponse['refresh_token']);
    // print("updateToken: ${sharedPreferences.get('token')}");
    clientCode = updateResponse['client_uuid'];
    // print("newRefToken: ${updateResponse['refresh_token']}");
  } else {
    updateResponse = json.decode(response.body);
    updateCode = updateResponse['code'];
    print("Error refresh with code: ${response.body}");
  }
  return updateCode;
}
