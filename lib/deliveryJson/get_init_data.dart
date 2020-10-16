import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';
import 'get_free_order_detail.dart';

var initData;
var deliverStatus;
var distanceToFirstPoint, distanceToSecondPoint;
int responseTime, arrivalTimeToFirstPoint, arrivalTimeToSecondPoint, arrivalUnixToFirstPoint, arrivalUnixToSecondPoint = 0;

Future<int> deliverInitData() async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/initdata';
  var body = json.encode("");
  var response = await http.post(url, body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    initData = json.decode(response.body);
    //print('InitData: ${response.body}');
    if (initData['order_data'] != null) {
      var responseUnix = initData['order_data']['offer']['response_time'];
      arrivalTimeToFirstPoint = initData['order_data']['offer']['route_to_client']['properties']['duration'] - 1;
      distanceToFirstPoint = initData['order_data']['offer']['route_to_client']['properties']['distance'] - 1;
      //    print('distanceToFirstPoint: ${distanceToFirstPoint.round()}');
      distanceToSecondPoint = initData['order_data']['order']['route_way_data']['routes']['properties']['distance'];
      //    print('distanceToSecondPoint: ${distanceToSecondPoint.round()}');
      arrivalTimeToSecondPoint = initData['order_data']['order']['route_way_data']['routes']['properties']['duration'];
      if (initData['order_data']['order']['products_data'] != null) {
        products = initData['order_data']['order']['products_data']['products'];
      } else {
        products = initData['order_data']['order']['products_data'];
      }
      deliverStatus = initData['order_data']['order_state']['value'];
      int currentUnix = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      responseTime = responseUnix - currentUnix;
      arrivalUnixToFirstPoint = currentUnix + arrivalTimeToFirstPoint;
    }
//    print('currentUnix $currentUnix');
//    print('arrivalUnixToFirstPoint $arrivalUnixToFirstPoint seconds');
//    print('responseTime $responseTime seconds');
//    print('arrivalTimeToFirstPoint $arrivalTimeToFirstPoint seconds');
//    print('arrivalTimeToSecondPoint $arrivalTimeToSecondPoint seconds');
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print(response.body);
  }
  print("getInit: ${response.statusCode}");
  return response.statusCode;
}