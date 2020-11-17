// To parse this JSON data, do
//
//     final driverStatusData = driverStatusDataFromJson(jsonString);

import 'dart:convert';

DriverStatusData driverStatusDataFromJson(String str) => DriverStatusData.fromJson(json.decode(str));

String driverStatusDataToJson(DriverStatusData data) => json.encode(data.toJson());

class DriverStatusData {
  DriverStatusData({
    this.code,
    this.message,
    this.driverState,
  });

  final int code;
  final String message;
  final DriverState driverState;

  factory DriverStatusData.fromJson(Map<String, dynamic> json) => DriverStatusData(
    code: json["code"],
    message: json["message"],
    driverState: DriverState.fromJson(json["driver_state"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "driver_state": driverState.toJson(),
  };
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

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
  };
}
