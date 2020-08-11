import 'dart:convert';

DeliverStatusData deliverStatusDataFromJson(String str) => DeliverStatusData.fromJson(json.decode(str));

class DeliverStatusData {
  DeliverStatusData({
    this.code,
    this.message,
    this.driverState,
  });

  final int code;
  final String message;
  final DriverState driverState;

  factory DeliverStatusData.fromJson(Map<String, dynamic> json) => DeliverStatusData(
    code: json["code"],
    message: json["message"],
    driverState: DriverState.fromJson(json["driver_state"]),
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
