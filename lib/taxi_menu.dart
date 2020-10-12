import 'dart:async';
import 'package:faem_delivery/Internet/internet_connection.dart';
import 'package:faem_delivery/Internet/show_pop_up.dart';
import 'package:faem_delivery/deliveryJson/deliver_verification.dart';
import 'package:faem_delivery/deliveryJson/get_driver_data.dart';
import 'package:faem_delivery/deliveryJson/get_history_data.dart';
import 'package:faem_delivery/deliveryJson/switch_deliver_status.dart';
import 'package:faem_delivery/history.dart';
import 'package:faem_delivery/main.dart';
import 'package:faem_delivery/user_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import 'auth_phone_screen.dart';

class TaxiMenu extends StatefulWidget {

  @override
  _TaxiMenuState createState() => _TaxiMenuState();
}

class _TaxiMenuState extends State<TaxiMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.0),
              height: MediaQuery.of(context).size.height * 0.1,
              child: IconButton(
                onPressed: () async {
                  if (await Internet.checkConnection()) {
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      isSwitched = false;
                      Navigator.pop(context);
                      PopUp.showInternetDialog();
                    });
                  }
                },
                icon: Icon(Icons.clear),
                color: Colors.black,
              ),
            ),
            FutureBuilder(
              future: getDriverData(),
              builder: (context,  snapshot) {
                if (balance != null) {
                  return Container(
                    child: ListTile(
                      leading: Transform(
                        transform:
                        Matrix4.translationValues(-25.0, 0.0, 0.0),
                        child: CircleAvatar(
                          radius: 54.0,
                          child: Image.asset('images/icons/deliver_icon.png'),
                        ),
                      ),
                      title: Transform(
                        transform:
                        Matrix4.translationValues(
                            -50.0, 0.0, 0.0),
                        child: Text(
                          '$drivName',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                        ),
                      ),
                      subtitle: Transform(
                        transform:
                        Matrix4.translationValues(
                            -50.0, 0.0, 0.0),
                        child: Text(
                          'Заработок: $earningsToday ₽',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Color(0xFF9D9C97)),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.only(left: 16.0),
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFFFD6F6D),
                    ),
                  );
                }
              }
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () async {
                        if (await Internet.checkConnection()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInformation()),
                          );
                        } else {
                          setState(() {
                            isSwitched = false;
                            Navigator.pop(context);
                            PopUp.showInternetDialog();
                          });
                        }
                      },
                      child: Container(
                        child: Transform(
                          transform:
                          Matrix4.translationValues(
                              -15.0, 0.0, 0.0),
                          child: ListTile(
                            title: Text(
                              'Профиль',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            subtitle: Text(
                              'Личная информация',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Color(0xFF9D9C97)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () async {
                        if (await Internet.checkConnection()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryList()),
                          );
                        } else {
                          setState(() {
                            isSwitched = false;
                            Navigator.pop(context);
                            PopUp.showInternetDialog();
                          });
                        }
                      },
                      child: Container(
                        child: Transform(
                          transform:
                          Matrix4.translationValues(
                              -15.0, 0.0, 0.0),
                          child: ListTile(
                            title: Text(
                              'История заказов',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            subtitle: Text(
                              'Доставки за день',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Color(0xFF9D9C97)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () async {
                        if (await Internet.checkConnection()) {
                          new Timer.periodic(Duration(seconds: 3), (Timer t) async {});
                          FlutterOpenWhatsapp.sendSingleMessage("+79891359399", "");
                        } else {
                          setState(() {
                            isSwitched = false;
                            Navigator.pop(context);
                            PopUp.showInternetDialog();
                          });
                        }
                        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MapScreen()), (route) => false);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Помощь',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () async {
                        if (await Internet.checkConnection()) {
                          await switchDeliverStatus('offline');
                          sharedPreferences.clear();
                          Navigator.push(context, new MaterialPageRoute(builder: (context) => AuthPhoneScreen()));
                        } else {
                          setState(() {
                            isSwitched = false;
                            Navigator.pop(context);
                            PopUp.showInternetDialog();
                          });
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Выход',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
