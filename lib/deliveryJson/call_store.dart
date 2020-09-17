import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';

Future<dynamic> callStore() async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/call/store';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    //print(response.body);
  } else {
    print("Error order with code ${response.statusCode}");
    print(response.body);
  }
  return response.statusCode;
}