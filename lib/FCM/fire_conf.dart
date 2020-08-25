import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Helper {
  static startFirebaseMessaging(BuildContext buildContext) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        var notification = message['notification'];
        final snackBar = SnackBar(
          content: Text(notification['title']),
          action: SnackBarAction(
              label: 'Ok',
              onPressed: (){}
          ),
        );

        try {
          Scaffold.of(buildContext).showSnackBar(snackBar);
        } catch (e) {
          print(e);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });
    print("Waiting for token...");
  }
}