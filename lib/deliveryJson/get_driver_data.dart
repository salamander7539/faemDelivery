import 'package:faem_delivery/deliveryJson/DriverData.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';



Future<DriverData> getDriverData() async {
  sharedPreferences = await SharedPreferences.getInstance();
  DriverData driverData;
  var url = 'https://driver.apis.stage.faem.pro/api/v2/driverdata';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    driverData = new DriverData.fromJson(jsonResponse);
  } else {
    print("driver: ${response.body}");
  }

  return driverData;
}