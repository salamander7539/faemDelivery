import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';
import 'get_free_order_detail.dart';

var initData;
var deliverStatus, deliverONState;
var distanceToFirstPoint, distanceToSecondPoint;
int responseTime, arrivalTimeToFirstPoint, arrivalTimeToSecondPoint, arrivalUnixToFirstPoint, arrivalUnixToSecondPoint = 0;

Future<dynamic> deliverInitData() async {
  sharedPreferences = await SharedPreferences.getInstance();
  var url = 'https://driver.apis.stage.faem.pro/api/v2/initdata';
  var body = json.encode("");
  http.Response response = await http.post(url, body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    initData = json.decode(response.body);
    // print('InitData: ${response.body}');
    deliverONState = initData['driver_state']['value'];
    if (initData['order_data'] != null) {
      var responseUnix = initData['order_data']['offer']['response_time'];
      arrivalTimeToFirstPoint = initData['order_data']['offer']['route_to_client']['properties']['duration'] - 1;
      distanceToFirstPoint = initData['order_data']['offer']['route_to_client']['properties']['distance'] - 1;
      distanceToSecondPoint = initData['order_data']['order']['route_way_data']['routes']['properties']['distance'];
      arrivalTimeToSecondPoint = initData['order_data']['order']['route_way_data']['routes']['properties']['duration'];
      if (initData['order_data']['order']['products_data'] != null) {
        products = initData['order_data']['order']['products_data']['products'];
      } else {
        products = null;
      }
      deliverStatus = initData['order_data']['order_state']['value'];
      int currentUnix = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      responseTime = responseUnix - currentUnix;
      arrivalUnixToFirstPoint = currentUnix + arrivalTimeToFirstPoint;
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print(response.body);
  }
  // print("getInit: ${response.statusCode}");
  return 200;
}