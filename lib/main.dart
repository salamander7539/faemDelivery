import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:faem_delivery/auth_code_screen.dart';
import 'package:faem_delivery/auth_phone_screen.dart';
import 'package:faem_delivery/deliveryJson/deliver_verification.dart';
import 'package:faem_delivery/deliveryJson/get_driver_data.dart';
import 'package:faem_delivery/deliveryJson/get_free_order_detail.dart';
import 'package:faem_delivery/deliveryJson/get_history_data.dart';
import 'package:faem_delivery/deliveryJson/get_init_data.dart';
import 'package:faem_delivery/deliveryJson/send_location.dart';
import 'package:faem_delivery/deliveryJson/switch_deliver_status.dart';
import 'package:faem_delivery/taxi_menu.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'deliveryJson/get_orders.dart';
import 'order_screen.dart';

void main() => runApp(DeliveryApp());

bool isSwitched;
double opacity = 0.5;
var orderUuid = "";
int chosenIndex = 0;
const oneMinute = const Duration(minutes: 1);
const fifteenSeconds = const Duration(seconds: 10);


class DeliveryApp extends StatefulWidget {
  @override
  _DeliveryAppState createState() => _DeliveryAppState();
}

final birthday = DateTime(1967, 10, 12);
final date2 = DateTime.now();
final difference = date2.difference(birthday).inSeconds;

class _DeliveryAppState extends State<DeliveryApp> with WidgetsBindingObserver {
  Timer timer;

  @override
  void initState() {
    //WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print('state = $state');
  // }

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
      home: DeliveryList(),
    );
  }
}

class DeliveryList extends StatefulWidget {
  @override
  _DeliveryListState createState() => _DeliveryListState();
}

Position currentPositionStart;

class _DeliveryListState extends State<DeliveryList> {

  DateTime backButtonPressedTime;
  var category;
  var answer;

  @override
  void initState() {
    opacity = 0.5;
    isSwitched = false;
    checkLoginStatus();
    new Timer.periodic(oneMinute, (Timer t) async {
      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.get('refToken') != null) {
        await updateRefreshToken(sharedPreferences.get('refToken'));
        await sendLocation();
      }
    });
    new Timer.periodic(fifteenSeconds, (Timer t) async {
      await _getCurrentLocationStart();
      await getDriverData();
      await getHistoryData();
      if (this.mounted) {
        setState(() {});
        if (orders != null) {
          print('orders: ${orders.length}');
        } else {
          print('orders: $orders');
        }
      }
    });
    super.initState();
  }

  _getCurrentLocationStart() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (this.mounted) {
        setState(() {
          currentPositionStart = position;
        });
      }
      print(
          "lat: ${currentPositionStart.latitude}, lng: ${currentPositionStart.longitude}");

    }).catchError((e) {
      print(e);
    });
  }

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("token: ${sharedPreferences.getString('token')}");
    if(sharedPreferences.getString('refToken') == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => AuthPhoneScreen()), (route) => false);
    } else if (sharedPreferences.getString('refToken') != null) {
      answer = await updateRefreshToken(sharedPreferences.get('refToken'));
      if (answer == 401) {
        _showDialog(updateResponse['message']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => AuthPhoneScreen()), (route) => false);
      }
    }
  }

  // _checkInternetConnectivity() async {
  //   var result = await Connectivity().checkConnectivity();
  //   if (result == ConnectivityResult.none) {
  //     _showDialog('No internet', "You're not connected to a network");
  //   } else if (result == ConnectivityResult.mobile) {
  //   } else if (result == ConnectivityResult.wifi) {}
  // }
  //
  _showDialog(text) {
    Fluttertoast.showToast(
        msg: "$text",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0,
    );
  }

  // Future<bool> _onBackPressed() {
  //   return showDialog(context: context,
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //
  //     );
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: TaxiMenu(),
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Color(0xFFECEEEC),
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
        elevation: 0.0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () async {
                await updateRefreshToken(sharedPreferences.get('refToken'));
                Scaffold.of(context).openDrawer();
              },
            );
          }
        ),
        title: Transform(
          transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
          child: Text(
            "Заказы",
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "UniNeue",
            ),
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
                  if (this.mounted) {
                    setState(() {
                      isSwitched = value;
                    });
                  }
                  if (isSwitched) {
                    await sendLocation();
                    await updateRefreshToken(sharedPreferences.get('refToken'));
                    await switchDeliverStatus("online");
                    if (this.mounted) {
                      setState(() {
                        opacity = 1;
                      });
                    }
                  } else {
                    await updateRefreshToken(sharedPreferences.get('refToken'));
                    await switchDeliverStatus("offline");
                    if (this.mounted) {
                      setState(() {
                        opacity = 0.5;
                      });
                    }
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
      body: Container(
        child: FutureBuilder(
            future: getOrdersData(),
            // ignore: missing_return
            builder: (context, AsyncSnapshot snapshot) {
              if (isSwitched && orders != null) {
                return ListView.builder(
                    itemCount: orders == null ? 0 : orders.length,
                    itemBuilder: (context, index) {
                      if (orders[index]['order']['routes'][0]['category'] == 'Рестораны') {
                        category = 'ресторана';
                      } else if (orders[index]['order']['routes'][0]['category'] == 'Аптеки') {
                        category = 'аптеки';
                      } else if (orders[index]['order']['routes'][0]['category'] == 'Магазины') {
                        category = 'магазина';
                      } else {
                        category = 'пункта назначения';
                      }
                      return Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 18.0,
                                                    bottom: 12.0,
                                                    left: 16.0),
                                                child: Text(
                                                  "Доставка из $category",
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
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 20.0),
                                                    child: Text(
                                                      (orders[index]['order']['tariff']['payment_type']).toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 11.0,
                                                        color: Color(0xFFFD6F6D),
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "UniNeue",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(color: Color(0xFFECEEEC)),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0,
                                                bottom: 12.0,
                                                left: 16.0,
                                                right: 16.0),
                                            child: ListTile(
                                              leading: Container(
                                                width: 18.0,
                                                height: 19.0,
                                                child: Image.asset(
                                                  "images/icons/restaurant_icon.png", fit: BoxFit.fill,
                                                ),
                                              ),
                                              title: Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                        -15.0, 0.0, 0.0),
                                                child: Text(
                                                  "${orders[index]['order']['routes'][0]['value']}",
                                                  style: TextStyle(
                                                    fontSize: 24.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "UniNeue",
                                                  ),
                                                ),
                                              ),
                                              subtitle: Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                        -15.0, 0.0, 0.0),
                                                child: Text(
                                                  "${orders[index]['order']['routes'][0]['street']}, ${orders[index]['order']['routes'][0]['house']} • ${(orders[index]['offer']['route_to_client']['properties']['distance'] / 1000).toStringAsFixed(1)}км от вас",
                                                  style: TextStyle(
                                                    color: Color(0xFF878A87),
                                                    fontSize: (16.0),
                                                    fontFamily: 'UniNeue',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0,
                                                left: 16.0,
                                                right: 16.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                ),
                                                onPressed: () async {
                                                  var accessCode =
                                                      await getDetailOrdersData(
                                                          orders[index]['offer']
                                                              ['uuid']);
                                                  if (accessCode == 200) {
                                                    deliverInitData();
                                                    Navigator.push(context, new MaterialPageRoute(builder: (context) => OrderPage()));
                                                  } else {
                                                    print(orderDetail['message']);
                                                  }
//                                                  int assignCode = await assignOrder(orders[index]['offer']['uuid']);
//                                                  if (assignCode == 200) {
//                                                    await deliverInitData();
//
//                                                  } else {
//                                                    return SnackBar(
//                                                      content: Text("Ошибка!"),
//                                                      action: SnackBarAction(
//                                                          label: 'Ok',
//                                                          onPressed: (){}
//                                                      ),
//                                                    );
//                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text(
                                                    "ПРИНЯТЬ ЗАКАЗ",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "UniNeue",
                                                    ),
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
                                      border: Border.all(
                                          color: Color(0xFFECEEEC), width: 1.0),
                                    ),
                                  ),
                                ),
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else if (!isSwitched) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 80.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Заказы вам не доступны",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                          ),
                        ),
                        Text(
                          "Чтобы получть доступ к свободным заказам пожалуйста перейдите в онлайн",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (isSwitched && orders == null) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 80.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "На данный момент заказы отсутсвуют",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                          ),
                        ),
                        Text(
                          "Ожидайте...",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}

