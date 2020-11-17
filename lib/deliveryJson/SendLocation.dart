// To parse this JSON data, do
//
//     final sendLocationData = sendLocationDataFromJson(jsonString);

import 'dart:convert';

SendLocationData sendLocationDataFromJson(String str) => SendLocationData.fromJson(json.decode(str));

String sendLocationDataToJson(SendLocationData data) => json.encode(data.toJson());

class SendLocationData {
  SendLocationData({
    this.code,
    this.message,
  });

  final int code;
  final String message;

  factory SendLocationData.fromJson(Map<String, dynamic> json) => SendLocationData(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}
