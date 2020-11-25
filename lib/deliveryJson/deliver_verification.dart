import 'package:faem_delivery/auth_code_screen.dart';
import 'package:faem_delivery/auth_phone_screen.dart';
import 'package:faem_delivery/deliveryJson/Verification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

int pinAnswerCode, status;
String refToken, token;
SharedPreferences sharedPreferences;

Future<VerificationData> loadCode(String deviceId, var code) async {
  VerificationData verificationData;
  sharedPreferences = await SharedPreferences.getInstance();
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
    verificationData = new VerificationData.fromJson(jsonResponse);
    token = verificationData.token;
    sharedPreferences.setString('token', verificationData.token);
    status = response.statusCode;
    refToken = verificationData.refreshToken;
    sharedPreferences.setString('refToken', verificationData.refreshToken);
  } else {
    status = response.statusCode;
    print('Request failed with status: ${response.statusCode}.');
    print(response.body);
  }
  return verificationData;
}

