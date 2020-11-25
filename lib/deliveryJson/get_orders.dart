import 'package:faem_delivery/deliveryJson/deliver_verification.dart';
import 'package:faem_delivery/deliveryJson/send_location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

List orders = [];
var errorCode;

Future<dynamic> getOrdersData() async {
  await sendLocation();
  sharedPreferences = await SharedPreferences.getInstance();
  var url = 'https://driver.apis.stage.faem.pro/api/v2/freeorders?number=30&sorttype=activity&service=Доставка';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.getString('token')}'
  });
  if (response.statusCode == 200) {
    orders = json.decode(response.body);
    errorCode = response.statusCode;
  } else {
    print("Error order with code ${response.statusCode}");
    errorCode = response.statusCode;
  }
  errorCode = response.statusCode;
  return orders;
}
