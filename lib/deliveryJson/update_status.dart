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
    //print("STATUS: ${response.body}");
  } else if (response.statusCode == 406) {
    var jsonResponse = json.decode(response.body);
    distanceToTarget = jsonResponse['distance_to_target'];
    stateOrder = jsonResponse['state'];
//    print("confirmDistance: $confirmDistance");

    message = jsonResponse['message'];
  } else {
    print('Request update failed with status: ${response.statusCode}.');
    print(response.body);
  }
  print('update: $body');
  print('statusCode ${response.statusCode}');
//  print(response.body);
  return response.statusCode;
}

OrderState orderStateFromJson(String str) =>
    OrderState.fromJson(json.decode(str));

String orderStateToJson(OrderState data) => json.encode(data.toJson());

class OrderState {
  OrderState({
    this.code,
    this.message,
    this.state,
  });

  final int code;
  final String message;
  final StatusState state;

  factory OrderState.fromJson(Map<String, dynamic> json) => OrderState(
        code: json["code"],
        message: json["message"],
        state: StatusState.fromJson(json["state"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "state": state.toJson(),
      };
}

class StatusState {
  StatusState({
    this.value,
    this.message,
  });

  final String value;
  final String message;

  factory StatusState.fromJson(Map<String, dynamic> json) => StatusState(
        value: json["value"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
      };
}
