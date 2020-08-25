import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<int> assignOrder(String offerUuid) async {
  print(offerUuid);
  var url = 'https://driver.apis.stage.faem.pro/api/v2/assignorder/$offerUuid';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $newToken'
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    var assign = AssignOrder.fromJson(jsonResponse);
    var message = assign.message;
    print("Assign: $message");
  } else {
    print('Assign failed with status: ${response.statusCode}.');
    print("Assign: ${response.body}");
  }
  print("Assign code: ${response.statusCode}");
  return response.statusCode;
}

AssignOrder assignOrderFromJson(String str) => AssignOrder.fromJson(json.decode(str));

String assignOrderToJson(AssignOrder data) => json.encode(data.toJson());

class AssignOrder {
  AssignOrder({
    this.code,
    this.message,
  });

  final int code;
  final String message;

  factory AssignOrder.fromJson(Map<String, dynamic> json) => AssignOrder(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}