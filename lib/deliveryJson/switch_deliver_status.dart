import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'deliver_status_data.dart';

var deliverValue;

Future<String> switchDeliverStatus(String statusValue) async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/setstate?state=$statusValue';
  var body = json.encode("");
  var response = await http.post(url, body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $newToken'
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    var deliverStatusData = new DeliverStatusData.fromJson(jsonResponse);
    deliverValue = deliverStatusData.driverState.value;
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print(response.body);
  }
  return deliverValue;
}
