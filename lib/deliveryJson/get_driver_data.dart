import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';

var balance, karma;
String drivName = '';

Future<void> getDriverData() async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/driverdata';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    drivName = jsonResponse['name'];
    balance = jsonResponse['balance'];
    karma = jsonResponse['karma'];
  } else {
    print("alerts: ${response.body}");
  }
}