import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';

var orderDetail;
List products = [];

Future<dynamic> getDetailOrdersData(var uuid) async {
  sharedPreferences = await SharedPreferences.getInstance();
  var url = 'https://driver.apis.stage.faem.pro/api/v2/freeorder/$uuid';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    orderDetail = json.decode(response.body);
    if (orderDetail['order']['products_data'] != null) {
      products = orderDetail['order']['products_data']['products'];
      print("ORDER ${orderDetail['order']}");
    } else {
      products = null;
    }
    //print(response.body);
  } else {
    print("Error order with code ${response.statusCode}");
    orderDetail = json.decode(response.body);
    print(response.body);
  }
  return response.statusCode;
}
