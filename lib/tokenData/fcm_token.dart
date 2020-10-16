import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'refresh_token.dart';

var fcmCode, fcmMessage;

Future<void> sendFcm(fcmTok) async {
  print("FCMTok: $fcmTok");
  var url = "https://driver.apis.stage.faem.pro/api/v2/firebasetoken";
  var body = json.encode({
    'token': "fcmToken"
  });
  var response = await http.post(url, body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $newToken'
  });
  if (response.statusCode == 200){
    print("FCM: ${response.body}");
    var jsonResponse = json.decode(response.body);
    fcmCode = jsonResponse['code'];
    fcmMessage = jsonResponse['message'];
  } else {
    print('Request fcm failed with status: ${response.statusCode}.');
    print("FCM: ${response.body}");
  }
}