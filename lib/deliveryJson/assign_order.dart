import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';

Future<int> assignOrder(String offerUuid) async {
  print(offerUuid);
  var url = 'https://driver.apis.stage.faem.pro/api/v2/assignorder/$offerUuid';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    var message = jsonResponse['message'];
  } else {
    print('Assign failed with status: ${response.statusCode}.');
    print("Assign: ${response.body}");
  }
  return response.statusCode;
}
