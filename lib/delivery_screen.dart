import 'package:faem_delivery/auth_code_screen.dart';
import 'package:faem_delivery/auth_phone_screen.dart';
import 'package:faem_delivery/deliveryJson/deliver_verification.dart';
import 'package:faem_delivery/deliveryJson/switch_deliver_status.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:flutter/material.dart';

import 'order_screen.dart';

void main() => runApp(DeliveryApp());

bool isSwitched;
double opacity = 0.5;

class DeliveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Заказы",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent,
        fontFamily: "UniNeue",
      ),
      routes: {
        "/deliveryPage": (context) => DeliveryList(),
        "/authPhonePage": (context) => AuthPhoneScreen(),
        "/authCodePage": (context) => AuthCodeScreen(),
        "/orderPage": (context) => OrderPage(),
      },
      home: AuthPhoneScreen(),
    );
  }
}

class DeliveryList extends StatefulWidget {
  @override
  _DeliveryListState createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  @override
  void initState() {
    isSwitched = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/authPhonePage");
          },
        ),
        title: Text(
          "Заказы",
          style: TextStyle(
            fontSize: 19.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: "UniNeue",
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Container(
              child: Switch(
                value: isSwitched,
                onChanged: (value) async {
                  setState(() {
                    isSwitched = value;
                  });
                  if (isSwitched) {
                    await updateRefreshToken(newRefToken);
                    await switchDeliverStatus("online");
                    setState(() {
                      opacity = 1;
                    });
                  } else {
                    await updateRefreshToken(newRefToken);
                    await switchDeliverStatus("offline");
                    setState(() {
                      opacity = 0.5;
                    });
                  }
                },
                inactiveTrackColor: Color(0xFFFF8064),
                activeTrackColor: Color(0xFFAFE14C),
                activeColor: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFFF7F7F7),
      resizeToAvoidBottomPadding: false,
      body: AbsorbPointer(
        absorbing: !isSwitched,
        ignoringSemantics: !isSwitched,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(milliseconds: 250),
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "(Задание)",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFFFD6F6D),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "UniNeue",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(36.0),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Color(0xFFFD6F6D)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 20.0),
                                            child: Text(
                                              "(Срочность)",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFFFD6F6D),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "UniNeue",
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(color: Colors.black),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ListTile(
                                      leading: Image.asset(
                                          "images/icons/restaurant_icon.png"),
                                      title: Text(
                                        "Название ресторана",
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "UniNeue",
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Адрес",
                                        style: TextStyle(
                                          color: Color(0xFF878A87),
                                          fontSize: (16.0),
                                          fontFamily: 'UniNeue',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 16.0, left: 16.0, right: 16.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/orderPage");
                                        },
                                        child: Text(
                                          "Принять заказ",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "UniNeue",
                                          ),
                                        ),
                                        color: Color(0xFFFD6F6D),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4.0),
                              color: Color(0xFFFFFFFF),
                              border: Border.all(color: Colors.black),
                            ),
                          ),
                        ),
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
