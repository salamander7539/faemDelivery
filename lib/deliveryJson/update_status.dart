import 'package:faem_delivery/deliveryJson/get_init_data.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';

var message, distanceToTarget, stateOrder;


Future<int> getStatusOrder(
    String orderStatus, String offerUuid, int arrivalTime, var distance) async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/order';
  var body = json.encode({
    "state": orderStatus,
    "offer_uuid": offerUuid,
    "time_arrival": arrivalTime,
    "confirm_distance": distance,
    "msg": ""
  });
  var response = await http.post(url, body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    stateOrder = jsonResponse['state'];
  } else if (response.statusCode == 406) {
    var jsonResponse = json.decode(response.body);
    distanceToTarget = jsonResponse['distance_to_target'];
    stateOrder = jsonResponse['state'];
    message = jsonResponse['message'];
  } else {
    print('Request update failed with status: ${response.statusCode}.');
    print(response.body);
  }
//  print(response.body);
  return response.statusCode;
}