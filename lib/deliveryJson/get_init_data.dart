import 'package:faem_delivery/deliveryJson/deliver_status_data.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

var initMessage, initValue;

Future<void> deliverInitData() async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/initdata';
  var body = json.encode("");
  var response = await http.post(url, body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $newToken'
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    var deliverInitData = new DeliverInitData.fromJson(jsonResponse);
    initMessage = deliverInitData.driverState.message;
    initValue = deliverInitData.driverState.value;
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print(response.body);
  }
}

DeliverInitData deliverInitDataFromJson(String str) => DeliverInitData.fromJson(json.decode(str));

class DeliverInitData {
  DeliverInitData({
    this.driverUuid,
    this.alias,
    this.operatorPhone,
    this.driverState,
    this.webViewHost,
  });

  final String driverUuid;
  final String alias;
  final String operatorPhone;
  final DriverState driverState;
  final String webViewHost;

  factory DeliverInitData.fromJson(Map<String, dynamic> json) => DeliverInitData(
    driverUuid: json["driver_uuid"],
    alias: json["alias"],
    operatorPhone: json["operator_phone"],
    driverState: DriverState.fromJson(json["driver_state"]),
    webViewHost: json["web_view_host"],
  );
}

class DriverState {
  DriverState({
    this.value,
    this.message,
  });

  final String value;
  final String message;

  factory DriverState.fromJson(Map<String, dynamic> json) => DriverState(
    value: json["value"],
    message: json["message"],
  );
}