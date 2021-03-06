import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:faem_delivery/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SendLocation.dart';
import 'deliver_verification.dart';


Future<SendLocationData> sendLocation() async {
  SendLocationData sendLocationData;
  sharedPreferences = await SharedPreferences.getInstance();
  var url = 'https://driver.apis.stage.faem.pro/api/v2/locations';
  var body = json.encode([
    {
      "lat": lat,
      "lng": lon,
      "time": (DateTime.now().millisecondsSinceEpoch / 1000).round(),
      "sats": 26
    }
  ]);
  if (sharedPreferences.get('token') != null) {

    var response = await http.post(url, body: body, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${sharedPreferences.get('token')}'
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      sendLocationData = new SendLocationData.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print(response.body);
    }
  }
  return sendLocationData;
}

