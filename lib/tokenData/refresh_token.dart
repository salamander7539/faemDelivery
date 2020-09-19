import 'package:faem_delivery/deliveryJson/deliver_verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

String newToken, clientCode, newRefToken;
var updateResponse, updateCode;

Future<dynamic> updateRefreshToken(String refresh) async {
  TokenNewData tokenNewData;
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
    print(response.body);
    tokenNewData = new TokenNewData.fromJson(updateResponse);
    updateCode = updateResponse['code'];
    newToken = updateResponse['token'];
    sharedPreferences.setString('token', updateResponse['token']);
    sharedPreferences.setString('refToken', updateResponse['refresh_token']);
    print("updateToken: ${sharedPreferences.get('token')}");
    clientCode = tokenNewData.client_uuid;
    newRefToken = tokenNewData.refresh_token;
    sharedPreferences.setString('jwt', newToken);
    print("newRefToken: $newRefToken");
  } else {
    updateResponse = json.decode(response.body);
    updateCode = updateResponse['code'];
    print("Error refresh with code: ${response.body}");
  }
  return updateCode;
}

class TokenNewData {
  // ignore: non_constant_identifier_names
  final String token;
  final String client_uuid;
  final String refresh_token;
  final int refresh_expiration;

  TokenNewData(
      {this.token,
      this.client_uuid,
      this.refresh_token,
      this.refresh_expiration});

  factory TokenNewData.fromJson(Map<String, dynamic> parsedJson) {
    return TokenNewData(
      token: parsedJson["token"] as String,
      client_uuid: parsedJson["client_uuid"] as String,
      refresh_token: parsedJson["refresh_token"] as String,
      refresh_expiration: parsedJson["refresh_expiration"] as int,
    );
  }
}
