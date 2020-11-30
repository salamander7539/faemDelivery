import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:faem_delivery/Internet/show_pop_up.dart';
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
int chosenIndex;
const oneMinute = const Duration(minutes: 1);
const fifteenSeconds = const Duration(seconds: 10);

class DeliveryApp extends StatefulWidget {
  @override
  _DeliveryAppState createState() => _DeliveryAppState();
}

var lat;
var lon;
final birthday = DateTime(1967, 10, 12);
final date2 = DateTime.now();
final difference = date2.difference(birthday).inSeconds;
var connectResult = true;

class _DeliveryAppState extends State<DeliveryApp> with WidgetsBindingObserver {
  Timer timer;
  var connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    //WidgetsBinding.instance.addObserver(this);
    super.initState();
    isSwitched = false;
    switchDeliverStatus('offline');
    // getLocation();
    // connectivity = new Connectivity();
    // subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
    //   print(result);
    //   if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile)  {
    //     getOrdersData();
    //     setState(() {
    //       connectResult = true;
    //       opacity = 1.0;
    //     });
    //     deliverInitData();
    //     if (initData['driver_state']['value'] == 'offline') {
    //       setState(() {
    //         isSwitched = false;
    //       });
    //     } else if (initData['driver_state']['value'] == 'online') {
    //       print('ONSTATE ${initData['driver_state']['value']}');
    //       setState(() {
    //         isSwitched = true;
    //       });
    //     }
    //   } else {
    //     setState(() {
    //       opacity = 0.5;
    //       connectResult = false;
    //       isSwitched = false;
    //     });
    //     PopUp.showInternetDialog("Ошибка подключения к интернету! \nПроверьте ваше интернет-соединение!");
    //   }
    // });
    new Timer.periodic(fifteenSeconds, (Timer t) async {
      await getLocation();
      await getDriverData();
      await getHistoryData();
      if (this.mounted) {
        setState(() {});
      }
      if (this.mounted) {
        if (orders != null) {
          // print('orders: ${orders.length}');
        } else {
          // print('orders: $orders');
        }
      }
    });
    new Timer.periodic(oneMinute, (Timer t) async {
      if (sharedPreferences.get('token') != null) {
        await updateRefreshToken(sharedPreferences.get('refToken'));
        await sendLocation();
      }
    });
  }


  getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }


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

final Stopwatch stopwatch = new Stopwatch();
var milliseconds;

class _DeliveryListState extends State<DeliveryList> {
  DateTime backButtonPressedTime;
  var category;
  var answer;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    stopwatch.start();
    stopwatch.stop();
    milliseconds = stopwatch.elapsedMicroseconds;
  }

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  _checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // print("token: ${sharedPreferences.getString('token')}");
    if (sharedPreferences.getString('refToken') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => AuthPhoneScreen()),
              (route) => false);
    } else if (sharedPreferences.getString('refToken') != null) {
      answer = await updateRefreshToken(sharedPreferences.get('refToken'));
      if (answer == 401) {
        await switchDeliverStatus('online');
        // _showDialog(updateResponse['message']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => AuthPhoneScreen()),
                (route) => false);
      } else {
        await deliverInitData();
        if (initData['order_data'] != null) {
          isSwitched = true;
          opacity = 1;
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OrderPage()));
        }
      }
    }
  }

  // _showDialog(text) {
  //   Fluttertoast.showToast(
  //     msg: "$text",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Color(0xFFF3F3F3),
  //     textColor: Colors.black,
  //     fontSize: 16.0,
  //   );
  // }

  _getOrdersList() {
    return new Scaffold(
      drawer: new TaxiMenu(),
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Color(0xFFECEEEC),
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
        elevation: 0.0,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Transform(
          transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
          child: Text(
            "Активные заказы",
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
                  if (await Internet.checkConnection()) {
                    if (this.mounted) {
                      setState(() {
                        isSwitched = value;
                      });
                      if (isSwitched) {
                        await sendLocation();
                        await switchDeliverStatus("online");
                      } else {
                        await switchDeliverStatus("offline");
                      }
                    }
                  } else {
                    PopUp.showInternetDialog('Ошибка подключения к интернету!\nПроверьте ваше интернет-соединение!');
                    return _bodyOfflineStatus("Подключение отсутвует", "Проверьте соединение с интернетом");
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
      body: _getFutureOrdersList(),
    );
  }

  _bodyOfflineStatus(offTitle, offSubtitle) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offTitle,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
            Text(
              offSubtitle,
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

  _orderWindow(orderIndex, orderCategory) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                "Доставка из $orderCategory",
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
                                    (orders[orderIndex]['order']['tariff']['payment_type']).toUpperCase(),
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
                                "images/icons/restaurant_icon.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Transform(
                              transform:
                              Matrix4.translationValues(-15.0, 0.0, 0.0),
                              child: Text(
                                "${orders[orderIndex]['order']['routes'][0]['value']}",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "UniNeue",
                                ),
                              ),
                            ),
                            subtitle: Transform(
                              transform: Matrix4.translationValues(
                                  -15.0, 0.0, 0.0),
                              child: Text(
                                "${orders[orderIndex]['order']['routes'][0]['street']}, ${orders[orderIndex]['order']['routes'][0]['house']} • ${(orders[orderIndex]['offer']['route_to_client']['properties']['distance'] / 1000).toStringAsFixed(1)}км от вас",
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
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0)),
                              ),
                              onPressed: () async {
                                if (await Internet.checkConnection()) {
                                  setState(() {
                                    chosenIndex = orderIndex;
                                  });
                                  var accessCode = await getDetailOrdersData(orders[chosenIndex]['offer']['uuid']);
                                  if (accessCode == 200) {
                                    await deliverInitData();
                                    Navigator.push(context, new MaterialPageRoute(builder: (context) => OrderPage()));
                                  }
                                } else {
                                  PopUp.showInternetDialog('Ошибка подключения к интернету!\nПроверьте ваше интернет-соединение!');
                                  return _bodyOfflineStatus("Подключение отсутвует", "Проверьте соединение с интернетом");
                                }
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.all(12.0),
                                child: Text(
                                  "ПРИНЯТЬ ЗАКАЗ",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
  }

  _getFutureOrdersList() {
    return FutureBuilder(
      future: getOrdersData(),
      // ignore: missing_return
      builder: (context, AsyncSnapshot snapshot) {
          if (isSwitched && snapshot.hasData) {
            return ListView.builder(
                itemCount: orders == null ? 0 : orders.length,
                itemBuilder: (context, index) {
                  switch (orders[index]['order']['routes'][0]['category']) {
                    case 'Рестораны':
                      category = 'ресторана';
                      break;
                    case 'Аптеки':
                      category = 'аптеки';
                      break;
                    case 'Магазины':
                      category = 'магазина';
                      break;
                    default :
                      category = 'заведения';
                      break;
                  }
                  return _orderWindow(index, category);
                });
          } else if (!isSwitched) {
            return _bodyOfflineStatus("Заказы вам не доступны", "Чтобы получить доступ к свободным заказам, пожалуйста перейдите в онлайн");
          } else if (isSwitched && !snapshot.hasData) {
            return _bodyOfflineStatus("На данный момент заказы отсутсвуют", "Ожидайте...");
          }
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getOrdersList();
  }
}