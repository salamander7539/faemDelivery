import 'package:faem_delivery/deliveryJson/HistoryData.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';

var countOfOrders, earningsToday;

Future<HistoryData> getHistoryData() async {
  HistoryData historyData;
  sharedPreferences = await SharedPreferences.getInstance();
  var url = 'https://driver.apis.stage.faem.pro/api/v2/incomedata';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    historyData = new HistoryData.fromJson(jsonResponse);
    //print('historyData: $jsonResponse');
    countOfOrders = historyData.countOfCompletedOrders;
    earningsToday = historyData.earningsToday;
  } else {
    await updateRefreshToken(sharedPreferences.get('refToken'));
    print("history: ${response.body}");
  }
  return historyData;
}