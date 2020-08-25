import 'package:faem_delivery/animations/button_animation.dart';
import 'package:faem_delivery/deliveryJson/assign_order.dart';
import 'package:faem_delivery/deliveryJson/get_free_order_detail.dart';
import 'package:faem_delivery/deliveryJson/get_init_data.dart';
import 'package:faem_delivery/deliveryJson/update_status.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';


import 'deliveryJson/switch_deliver_status.dart';
import 'delivery_screen.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

bool clientVisibility;

bool deniedCallVisibility = false;
var indexCoef = 2;
var arrivalTime;

class _OrderPageState extends State<OrderPage> {
  String buttonStatus;
  bool phoneVisibility;

  onStartOrder (newStatus) {
    setState(() {
      buttonStatus = newStatus;
    });
  }

  createAlertDialog(BuildContext context, String status, String mes) {
    print(message);
    int distance;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(mes != null ? mes : "0",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
        ),
        content: TextField(
          onChanged: (newDistance) {
            setState(() {
              distance = int.parse(newDistance);
            });
          },
          decoration: InputDecoration(
            border: new UnderlineInputBorder(
              borderSide: new BorderSide(
                color: Color(0xFFFD6F6D),
              ),
            ),
            focusColor: Color(0xFFFD6F6D),
            enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(
                color: Color(0xFFFD6F6D),
              ),
            ),
            focusedBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(
                color: Color(0xFFFD6F6D),
                width: 2.0,
              ),
            ),
          ),
        ),

        actions: [
          FlatButton(
            onPressed: () async {
              var answer = await getStatusOrder(status, orderDetail['offer']['uuid'], null, distance);
              if (answer == 200) {
                await deliverInitData();
                if (deliverStatus == "on_place"){
                  await getStatusOrder('on_the_way', orderDetail['offer']['uuid'], null, distance);
                  await deliverInitData();
                }
                Navigator.pop(context);
              }
            },
            child: Text("OK",
              style: TextStyle(
                color: Color(0xFFFF8064),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  var controller = new MaskedTextController(
      mask: '+0 000 000-00-00',
      text: orderDetail['order']['client']['main_phone']);
  var now = DateTime.now();
  var currentId;
  int buttonIndex;
  List<double> coef = [0.5, 0.75, 1, 1.25, 1.5];

  String formattedDate = DateFormat('ddMMyy').format(DateTime.now());

  @override
  void initState() {
    String orderId = orderDetail['order']['uuid'];
    currentId = orderId.substring(orderId.length - 4);
    print(currentId);
    deliverStatus = null;
    clientVisibility = false;
    phoneVisibility = false;
    buttonIndex = 2;
    buttonStatus = 'ПРИНЯТЬ ЗАКАЗ';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusCode;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: ListTile(
          title: Text(
            "Заказ",
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "UniNeue",
            ),
          ),
          subtitle: Text(
            "$formattedDate-$currentId",
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () async {
//            if (orders[chosenIndex]['offer']['uuid'] != null) {
//              await getStatusOrder(
//                  "offer_rejected", orders[chosenIndex]['offer']['uuid']);
//            }
            Navigator.pop(context);
          },
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
      backgroundColor: Colors.white,
      body: AbsorbPointer(
        absorbing: !isSwitched,
        ignoringSemantics: !isSwitched,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(milliseconds: 250),
          child: Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Прибыть в ресторан",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFFFD6F6D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Visibility(
                                    visible: phoneVisibility,
                                    child: Text(
                                      "(Время прибытия)",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(36.0),
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFFFD6F6D)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 20.0),
                                  child: Text(
                                    "СРОЧНО",
                                    style: TextStyle(
                                      fontSize: 10.0,
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
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.asset(
                                      "images/icons/restaurant_icon.png"),
                                ),
                                Text(
                                  "${orderDetail['order']['routes'][0]['value']}",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "UniNeue",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        subtitle: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${orderDetail['order']['routes'][0]['street']}, ${orderDetail['order']['routes'][0]['house']}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: (16.0),
                                  fontFamily: 'UniNeue',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.asset("images/icons/map_icon.png")
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Divider(
                        color: Color(0xFFECEEEC),
                      ),
                    ),
                    Visibility(
                      visible: clientVisibility,
                      child: Container(
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.person_outline),
                                  ),
                                  Text(
                                    "${orderDetail['order']['routes'][1]['value']}",
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "UniNeue",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          subtitle: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${orderDetail['order']['routes'][1]['street']}, ${orderDetail['order']['routes'][1]['house']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: (16.0),
                                    fontFamily: 'UniNeue',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Image.asset("images/icons/map_icon.png")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: phoneVisibility,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "Номер телефона:",
                                  style: TextStyle(
                                    color: Color(0xFFB8BAB8),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.text,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3.5),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.call),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: clientVisibility,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: orderDetail['order']['client']['comment'] != ""
                          ? true
                          : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          child: ListTile(
                            title: Text(
                              "Комментарий ресторана:",
                              style: TextStyle(
                                color: Color(0xFFB8BAB8),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${orderDetail['offer']['comment']}",
                              //['order']['client']['comment']
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: products != null ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "Состав заказа:",
                                  style: TextStyle(
                                    color: Color(0xFFB8BAB8),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4.0, left: 15.0),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  children: List.generate(
                                    products != null ? products.length : 0,
                                    (index) {
                                      return Text(
                                        "${orderDetail['order']['products_data']['products'][index]['number']} x ${orderDetail['order']['products_data']['products'][index]['name']}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        child: ListTile(
                          title: Text(
                            "Оплата:",
                            style: TextStyle(
                              color: Color(0xFFB8BAB8),
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Сумма по заказу: ${orderDetail['order']['tariff']['total_price']}₽\nОплата: ${orderDetail['order']['tariff']['payment_type']}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: StatefulBuilder(builder: (BuildContext context, StateSetter setButtonState) {
                              return RaisedButton(
                                ////////////////////////////////////////////////////////////////////
                                onPressed: () async {
                                    if (deliverStatus == "order_start") {
                                      statusCode = await getStatusOrder('on_place', orderDetail['offer']['uuid'], null, 0);
                                      if (statusCode == 200) {
                                        await deliverInitData();
                                        setState(() async {
                                          await getStatusOrder('on_the_way', orderDetail['offer']['uuid'], null, null);
                                          await deliverInitData();
                                          clientVisibility = true;
                                          buttonStatus = 'ПРИБЫЛ К КЛИЕНТУ';
                                        });
                                      } else if (statusCode == 406) {
                                        createAlertDialog(context, 'on_place', message);
                                        await deliverInitData();
                                        setState(() async {
                                          await deliverInitData();
                                          clientVisibility = true;
                                          buttonStatus = 'ПРИБЫЛ К КЛИЕНТУ';
                                        });
                                      }
                                    }
                                    if (deliverStatus == 'on_the_way') {
                                      statusCode = await getStatusOrder('order_payment', orderDetail['offer']['uuid'], null, null);
                                      if (statusCode == 200) {
                                        await deliverInitData();
                                        setState(() {
                                          buttonStatus = 'ОТДАЛ ЗАКАЗ';
                                          deliverStatus =
                                          initData['order_data']['order_state']['value'];
                                        });
                                      } else if (statusCode == 406) {
                                        createAlertDialog(context, 'order_payment', message);
                                        await deliverInitData();
                                        setState(() {
                                          buttonStatus = 'ОТДАЛ ЗАКАЗ';
                                          deliverStatus =
                                          initData['order_data']['order_state']['value'];
                                        });
                                      }
                                    }
                                    if(deliverStatus == "order_payment") {
                                      await getStatusOrder('finished',
                                          orderDetail['offer']['uuid'], null,
                                          null);
                                      Navigator.pop(context);
                                    }
                                    if (deliverStatus == null) {
                                      setState(() {
                                        phoneVisibility = true;
                                      });
                                      await updateRefreshToken(newRefToken);
                                      var assignCode = await assignOrder(orderDetail['offer']['uuid']);
                                      if (assignCode == 200) {
                                        var statusCode = await getStatusOrder('offer_offered', orderDetail['offer']['uuid'], null, null);
                                        if (statusCode == 200) {
                                          var initCode = await deliverInitData();
                                          if (initCode == 200) {
                                            int currentTimeUnix = (DateTime.now().millisecondsSinceEpoch / 1000).round();
                                            arrivalTime = ((arrivalTimeToFirstPoint + currentTimeUnix)).round();
                                            buttonIndex = 2;
                                            return showModalBottomSheet(
                                                context: context,
                                                backgroundColor: Colors.white,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter setModalState) {
                                                        return Container(
                                                          height: MediaQuery.of(context).size.height * .265,
                                                          child: Visibility(
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.all(16.0),
                                                                  child: Wrap(
                                                                    direction: Axis.horizontal,
                                                                    children: List.generate(5, (index) {
                                                                      return Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 7.5),
                                                                        child: SizedBox(
                                                                          child: FlatButton(
                                                                            onPressed: () async {
                                                                              setModalState(() {
                                                                                arrivalTime = ((arrivalTimeToFirstPoint * coef[index] + currentTimeUnix)).round();
                                                                                buttonIndex = index;
                                                                                print("B $buttonIndex");
                                                                              });
                                                                              print("arrivalTime $arrivalTime");
                                                                            },
                                                                            child: Text(
                                                                              "${((arrivalTimeToFirstPoint * coef[index]) / 60).round()}",
                                                                              style: TextStyle(
                                                                                color: buttonIndex != index ? Colors.black : Color(0xFFFD6F6D),
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 25.0,
                                                                              ),
                                                                            ),
                                                                            color: Color(0xFFEEEEEE),
                                                                          ),
                                                                          width: 60.0,
                                                                          height: 60.0,
                                                                        ),
                                                                      );
                                                                    }),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.symmetric(horizontal: 24.0),
                                                                  child: Container(
                                                                    child: ButtonAnimation(
                                                                        primaryColor: Color(0xFFFD6F6D),
                                                                        darkPrimaryColor: Color(0xFF33353E), orderFunction: onStartOrder),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      left: 24.0,
                                                                      right: 24.0,
                                                                      top: 15.0),
                                                                  child: Container(
                                                                    child: Text("Пожалуйста, укажите максимально точное время прибытия к клиенту"),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                });
                                          }
                                        }
                                      }
                                    }
                                },
                                color: Color(0xFFFD6F6D),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    buttonStatus,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                      Visibility(
                        visible: deniedCallVisibility,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: FlatButton(
                              onPressed: () {},
                              color: Colors.white,
                              child: Text(
                                "КЛИЕНТ НЕ ВЫШЕЛ НА СВЯЗЬ",
                                style: TextStyle(
                                    color: Color(0xFFFD6F6D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
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
        ),
      ),
    );
  }
}
