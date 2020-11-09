import 'package:faem_delivery/auth_phone_screen.dart';
import 'package:faem_delivery/deliveryJson/deliver_verification.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'deliveryJson/deliver_auth.dart';
import 'deliveryJson/remind_password.dart';
import 'main.dart';

class AuthCodeScreen extends StatefulWidget {
  @override
  _AuthCodeScreenState createState() => _AuthCodeScreenState();
}

final Stopwatch stopwatch = new Stopwatch();

Position currentPosition;

String pin;

class _AuthCodeScreenState extends State<AuthCodeScreen> {
  TextEditingController pinController = new TextEditingController();
  Color buttonCodeColor, buttonCodeTextColor;
  bool buttonCodeEnable, smsWarning;

  @override
  void initState() {
    super.initState();
    buttonCodeColor = Color(0xFFF3F3F3);
    buttonCodeTextColor = Colors.black;
    buttonCodeEnable = true;
    smsWarning = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Color(0xFFECEEEC),
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 76.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Введите код из смс",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "UniNeue",
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Container(
                          child: PinInputTextField(
                            autoFocus: true,
                            controller: pinController,
                            pinLength: 4,
                            decoration: UnderlineDecoration(
                              color: Color(0xFFFD6F6D),
                              hintText: "0000",
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,
                              ),
                            ),
                            inputFormatter: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (String newPin) async {
                              if (this.mounted) {
                                setState(() {
                                  pin = newPin;
                                  // print("pin: $pin");
                                  if (pin.length == 4) {
                                    buttonCodeColor = Color(0xFFFD6F6D);
                                    buttonCodeTextColor = Colors.white;
                                    buttonCodeEnable = false;
                                  } else {
                                    buttonCodeColor = Color(0xFFF3F3F3);
                                    buttonCodeTextColor = Colors.black;
                                    buttonCodeEnable = true;
                                    smsWarning = false;
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: smsWarning,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text(
                            "Вы ввели неверный смс код",
                            style: TextStyle(
                                color: Color(0xFFEE4D3F),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 20.0,
                        child: FlatButton(
                          onPressed: () async {
                            await remindPassword();
                          },
                          color: Colors.transparent,
                          child: Text(
                            remindMessage != null ? remindMessage : '',
                            style: TextStyle(
                              color: (Color(0xFF979797)),
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    visible: remindMessage != null ? true : false,
                  ),
                  AbsorbPointer(
                    absorbing: buttonCodeEnable,
                    child: Container(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(11.0)),
                          ),
                          color: buttonCodeColor,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Готово",
                              style: TextStyle(
                                color: buttonCodeTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (pin.length == 4) {
                              await loadCode(phone, pin);
                              sharedPreferences = await SharedPreferences.getInstance();
                              await updateRefreshToken(refToken);
                              if (status == 200) {
                                setState(() {
                                  sharedPreferences.setString('token', updateResponse['token']);
                                });
                                milliseconds = (DateTime.now().millisecondsSinceEpoch / 1000).round();
                                // print("time: $milliseconds ");
                                Navigator.pushNamed(context, "/deliveryPage");
                                pinController.clear();
                              } else {
                                if (this.mounted) {
                                  setState(() {
                                    pinController.clear();
                                    smsWarning = true;
                                  });
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
