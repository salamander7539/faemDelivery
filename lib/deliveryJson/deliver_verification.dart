import 'package:faem_delivery/auth_code_screen.dart';
import 'package:faem_delivery/auth_phone_screen.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

int pinAnswerCode, status;
String refToken, token;
SharedPreferences sharedPreferences;

Future<TokenData> loadCode(String deviceId, var code) async {
  sharedPreferences = await SharedPreferences.getInstance();
  TokenData getToken;
  var jsonRequest = json.encode({
    "device_id": deviceId,
    "phone": phone,
    "password": pin,
  });
  var url = "https://driver.apis.stage.faem.pro/api/v2/auth/verification";
  var response =
      await http.post(url, body: jsonRequest, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    getToken = new TokenData.fromJson(jsonResponse);
    token = getToken.token;
    status = response.statusCode;
    refToken = getToken.refresh_token;
    print(response.body);
    print("refToken: $refToken");
  } else {
    status = response.statusCode;
    print('Request failed with status: ${response.statusCode}.');
    print(response.body);
  }
  return getToken;
}

class TokenData {
  // ignore: non_constant_identifier_names
  final int driver_id;
  final String token;
  final String client_uuid;
  final String refresh_token;
  final int refresh_expiration;

  TokenData(
      {this.driver_id,
      this.token,
      this.client_uuid,
      this.refresh_token,
      this.refresh_expiration});

  factory TokenData.fromJson(Map<String, dynamic> parsedJson) {
    return TokenData(
      driver_id: parsedJson["driver_id"] as int,
      token: parsedJson["token"] as String,
      client_uuid: parsedJson["client_uuid"] as String,
      refresh_token: parsedJson["refresh_token"] as String,
      refresh_expiration: parsedJson["refresh_expiration"] as int,
    );
  }
}
