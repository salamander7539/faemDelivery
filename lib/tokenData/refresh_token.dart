import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

String newToken, clientCode, newRefToken;

Future<void> updateRefreshToken(String refresh) async {
  TokenNewData tokenNewData;
  var jsonBody = json.encode({
    "refresh": refresh,
  });
  const url = "https://driver.apis.stage.faem.pro/api/v2/auth/refresh";
  var response = await http.post(url, body: jsonBody, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    tokenNewData = new TokenNewData.fromJson(jsonResponse);
    newToken = tokenNewData.token;
    clientCode = tokenNewData.client_uuid;
    newRefToken = tokenNewData.refresh_token;
    print("newToken: $newToken");
    print("newRefToken: $newRefToken");
  } else {
    print("Error refresh with code: ${response.statusCode}");
  }
}

class TokenNewData {
  // ignore: non_constant_identifier_names
  final String token;
  final String client_uuid;
  final String refresh_token;
  final int refresh_expiration;

  TokenNewData(
      {this.token,
      this.client_uuid,
      this.refresh_token,
      this.refresh_expiration});

  factory TokenNewData.fromJson(Map<String, dynamic> parsedJson) {
    return TokenNewData(
      token: parsedJson["token"] as String,
      client_uuid: parsedJson["client_uuid"] as String,
      refresh_token: parsedJson["refresh_token"] as String,
      refresh_expiration: parsedJson["refresh_expiration"] as int,
    );
  }
}
