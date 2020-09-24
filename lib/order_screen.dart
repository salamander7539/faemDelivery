import 'package:faem_delivery/animations/button_animation.dart';
import 'package:faem_delivery/deliveryJson/assign_order.dart';
import 'package:faem_delivery/deliveryJson/call_client.dart';
import 'package:faem_delivery/deliveryJson/deliver_verification.dart';
import 'package:faem_delivery/deliveryJson/get_free_order_detail.dart';
import 'package:faem_delivery/deliveryJson/get_init_data.dart';
import 'package:faem_delivery/deliveryJson/update_status.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deliveryJson/get_orders.dart';
import 'deliveryJson/switch_deliver_status.dart';
import 'main.dart';

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

  onStartOrder(newStatus) {
    setState(() {
      buttonStatus = newStatus;
    });
  }

  createAlertDialog(
      BuildContext context, String status, String mes, String buttonState) {
    print(message);
    int distance;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          mes != null ? mes : "0",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
        ),
        content: TextField(
          keyboardType: TextInputType.phone,
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
              if (initData['order_data'] == null) {
                var answer = await getStatusOrder(
                    status, orderDetail['offer']['uuid'], null, distance);
                if (answer == 200) {
                  await deliverInitData();
                  if (deliverStatus == "on_place") {
                    await getStatusOrder('on_the_way',
                        orderDetail['offer']['uuid'], null, distance);
                    await deliverInitData();
                    setState(() {
                      buttonStatus = buttonState;
                    });
                  } else {
                    print("buttonState $buttonState");
                    await getStatusOrder('order_payment',
                        orderDetail['offer']['uuid'], null, distance);
                    await deliverInitData();
                    setState(() {
                      buttonStatus = buttonState;
                    });
                  }
                  Navigator.pop(context);
                }
              } else {
                var answer = await getStatusOrder(
                    status, initData['order_data']['offer']['uuid'], null, distance);
                if (answer == 200) {
                  await deliverInitData();
                  if (deliverStatus == "on_place") {
                    await getStatusOrder('on_the_way',
                        initData['order_data']['offer']['uuid'], null, distance);
                    await deliverInitData();
                    setState(() {
                      buttonStatus = buttonState;
                    });
                  } else {
                    print("buttonState $buttonState");
                    await getStatusOrder('order_payment',
                        initData['order_data']['offer']['uuid'], null, distance);
                    await deliverInitData();
                    setState(() {
                      buttonStatus = buttonState;
                    });
                  }
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              "OK",
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
      text: initData['order_data'] == null ? orderDetail['order']['client']['main_phone'] : initData['order_data']['order']['client']['main_phone']) ;
  var now = DateTime.now();
  var currentId;
  int buttonIndex;
  String switchToClient;
  String orderComment;
  var feature;
  var category;
  List<double> coef = [0.5, 0.75, 1, 1.25, 1.5];
  var fondTimeSize = 25.0;
  var guarantPrice;
  String formattedDate = DateFormat('ddMMyy').format(DateTime.now());

  @override
  void initState() {
    if (initData['order_data'] == null) {
      String orderId = orderDetail['order']['uuid'];
      currentId = orderId.substring(orderId.length - 4);
      print(currentId);
      deliverStatus = null;
      if (orderDetail['order']['tariff']['total_price'] <
          orderDetail['order']['tariff']['guaranteed_driver_income']) {
        guarantPrice = orderDetail['order']['tariff']['guaranteed_driver_income'];
      } else {
        guarantPrice = orderDetail['order']['tariff']['total_price'];
      }
      clientVisibility = false;
      phoneVisibility = false;
      buttonIndex = 2;
      if (orderDetail['order']['routes'][0]['category'] == 'Рестораны') {
        category = 'ресторана';
      } else if (orderDetail['order']['routes'][0]['category'] == 'Аптеки') {
        category = 'аптеки';
      } else if (orderDetail['order']['routes'][0]['category'] == 'Магазины') {
        category = 'магазина';
      } else {
        category = 'пункта назначения';
      }
      orderComment = (orderDetail['order']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
          ? orderDetail['order']['comment']
          : null;
      print('comment $orderComment');
      print("features: ${(orderDetail['order']['features'])}");
      if ((orderDetail['order']['features']) == null ||
          (orderDetail['order']['features']).isEmpty) {
        feature = '';
      } else {
        feature = orderDetail['order']['features'][0]['name'];
      }
      buttonStatus = 'ПРИНЯТЬ ЗАКАЗ';
      if (isSwitched = true) {
        opacity = 1;
      }
    } else {
      String orderId = initData['order_data']['order']['uuid'];
      currentId = orderId.substring(orderId.length - 4);
      print(currentId);
      deliverStatus = initData['order_data']['order_state']['value'];
      if (initData['order_data']['order']['tariff']['total_price'] <
          initData['order_data']['order']['tariff']['guaranteed_driver_income']) {
        guarantPrice = initData['order_data']['order']['tariff']['guaranteed_driver_income'];
      } else {
        guarantPrice = initData['order_data']['order']['tariff']['total_price'];
      }
      clientVisibility = false;
      phoneVisibility = true;
      buttonIndex = 2;
      if (initData['order_data']['order']['routes'][0]['category'] == 'Рестораны') {
        category = 'ресторана';
      } else if (initData['order_data']['order']['routes'][0]['category'] == 'Аптеки') {
        category = 'аптеки';
      } else if (initData['order_data']['order']['routes'][0]['category'] == 'Магазины') {
        category = 'магазина';
      } else {
        category = 'пункта назначения';
      }
      print("features: ${(initData['order_data']['order']['features'])}");
      if ((initData['order_data']['order']['features']) == null ||
          (initData['order_data']['order']['features']).isEmpty) {
        feature = '';
      } else {
        feature = initData['order_data']['order']['features'][0]['name'];
      }
      switch (deliverStatus) {
        case 'order_start' :
          switchToClient = 'Комментрарий ресторана';
          orderComment = (initData['order_data']['order']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? initData['order_data']['order']['comment']
              : null;
          buttonStatus = 'ПРИБЫЛ К ЗАВЕДЕНИЮ';
          break;
        case 'on_the_way' :
          switchToClient = (initData['order_data']['order']
          ['client']['comment'])
              .contains(new RegExp(
              r'[A-Za-z0-9а-яА-Я]'))
              ? "Комментарий клиента:"
              : switchToClient;
          orderComment = (initData['order_data']['order']
          ['client']['comment'])
              .contains(new RegExp(
              r'[A-Za-z0-9а-яА-Я]'))
              ? initData['order_data']['order']['client']
          ['comment']
              : null;
          buttonStatus = 'ПРИБЫЛ К КЛИЕНТУ';
          break;
        case 'order_payment' :
          switchToClient = (initData['order_data']['order']
          ['client']['comment'])
              .contains(new RegExp(
              r'[A-Za-z0-9а-яА-Я]'))
              ? "Комментарий клиента:"
              : switchToClient;
          orderComment = (initData['order_data']['order']
          ['client']['comment'])
              .contains(new RegExp(
              r'[A-Za-z0-9а-яА-Я]'))
              ? initData['order_data']['order']['client']
          ['comment']
              : null;
          buttonStatus = 'ОТДАЛ ЗАКАЗ';
          break;
        default:
          switchToClient = 'Комментрарий ресторана';
          orderComment = (initData['order_data']['order']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? initData['order_data']['order']['comment']
              : null;
          buttonStatus = "ПРИНЯТЬ ЗАКАЗ";
          break;
      }
      if (isSwitched = true) {
        opacity = 1;
      }
    }
    print('feature $feature');
    switchToClient = "Комментарий ресторана:";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusCode;
    return WillPopScope(
      onWillPop: () async {
        if (orders[chosenIndex]['offer']['uuid'] != null) {
          await getStatusOrder("offer_rejected",
              orders[chosenIndex]['offer']['uuid'], null, null);
        }
        Navigator.pop(context);
        return null;
      },
      child: FutureBuilder(
        future: initData['order_data'] == null ? getDetailOrdersData(orders[chosenIndex]['offer']['uuid']) : deliverInitData(),
        // ignore: missing_return
        builder: (context, AsyncSnapshot snapshot) {
          if (initData['order_data'] == null) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                bottom: PreferredSize(
                    child: Container(
                      color: Color(0xFFECEEEC),
                      height: 1.0,
                    ),
                    preferredSize: Size.fromHeight(1.0)),
                elevation: 0.0,
                title: ListTile(
                  title: Transform(
                    transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
                    child: Text(
                      "Заказ",
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "UniNeue",
                      ),
                    ),
                  ),
                  subtitle: Transform(
                    transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
                    child: Text(
                      "$formattedDate-$currentId",
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    if (orders[chosenIndex]['offer']['uuid'] != null) {
                      await getStatusOrder("offer_rejected",
                          orders[chosenIndex]['offer']['uuid'], null, null);
                    }
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
                          sharedPreferences = await SharedPreferences.getInstance();
                          setState(() {
                            isSwitched = value;
                          });
                          if (isSwitched) {
                            await updateRefreshToken(
                                sharedPreferences.get('refToken'));
                            await switchDeliverStatus("online");
                            setState(() {
                              opacity = 1;
                            });
                          } else {
                            await updateRefreshToken(
                                sharedPreferences.get('refToken'));
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
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
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
                                              "Доставка из $category",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFFFD6F6D),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // Visibility(
                                            //   visible: phoneVisibility,
                                            //   child: Text(
                                            //     "(Время прибытия)",
                                            //     style: TextStyle(
                                            //       fontSize: 14.0,
                                            //       color: Colors.black,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),
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
                                            border:
                                                Border.all(color: Color(0xFFFD6F6D)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0, horizontal: 20.0),
                                            child: Text(
                                              (orderDetail['order']['tariff']
                                                      ['payment_type'])
                                                  .toUpperCase(),
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
                              ),
                              Divider(
                                color: Color(0xFFECEEEC),
                              ),
                              Container(
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Container(
                                              width: 18.0,
                                              height: 19.0,
                                              child: Image.asset(
                                                "images/icons/restaurant_icon.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
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
                                          "${orderDetail['order']['routes'][0]['street']}, ${orderDetail['order']['routes'][0]['house']} • ${(orderDetail['offer']['route_to_client']['properties']['distance'] / 1000).toStringAsFixed(1)}км от вас",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: (16.0),
                                            fontFamily: 'UniNeue',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Container(
                                        //   width: 17.0,
                                        //   height: 15.0,
                                        //   child: ConstrainedBox(
                                        //     constraints: BoxConstraints.expand(),
                                        //     child: Ink.image(
                                        //       image: AssetImage('images/icons/map_icon.png'),
                                        //       fit: BoxFit.fill,
                                        //       child: InkWell(
                                        //         onTap: () {
                                        //           Navigator.of(context)
                                        //               .push(MaterialPageRoute(
                                        //             builder: (context) => MapScreen(
                                        //                 orderDetail['order']['routes'][0]
                                        //                 ['lat'],
                                        //                 orderDetail['order']['routes'][0]
                                        //                 ['lon']),
                                        //           ));
                                        //         },
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
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
                                visible: true,
                                child: Container(
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.person_outline),
                                            ),
                                            Text(
                                              (orderDetail['order']['routes']).length > 1 ? orderDetail['order']['routes'][1]['value'] : "",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            (orderDetail['order']['routes']).length > 1
                                                ? "${orderDetail['order']['routes'][1]['street']}, ${orderDetail['order']['routes'][1]['house']} • ${((orderDetail['order']['route_way_data']['routes']['properties']['distance']) / 1000).toStringAsFixed(1)}км от вас"
                                                : "",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: (16.0),
                                              fontFamily: 'UniNeue',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Container(
                                          //   width: 17.0,
                                          //   height: 15.0,
                                          //   child: ConstrainedBox(
                                          //     constraints: BoxConstraints.expand(),
                                          //     child: Ink.image(
                                          //       image: AssetImage('images/icons/map_icon.png'),
                                          //       fit: BoxFit.fill,
                                          //       child: InkWell(
                                          //         onTap: () {
                                          //           Navigator.of(context)
                                          //               .push(MaterialPageRoute(
                                          //             builder: (context) => MapScreen(
                                          //                 orderDetail['order']['routes'][1]
                                          //                 ['lat'],
                                          //                 orderDetail['order']['routes'][1]
                                          //                 ['lon']),
                                          //           ));
                                          //         },
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
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
                                                    onPressed: () async {
                                                      await callClient();
                                                    },
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
                              // Visibility(
                              //   visible: clientVisibility,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 16.0),
                              //     child: Divider(
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              Visibility(
                                visible: orderComment != null ? true : false,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Container(
                                    child: ListTile(
                                      title: Text(
                                        switchToClient,
                                        style: TextStyle(
                                          color: Color(0xFFB8BAB8),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        orderComment != null ? orderComment : "",
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
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            "СОСТАВ ЗАКАЗА:",
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
                                padding: const EdgeInsets.only(bottom: 16.0),
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
                                    subtitle: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width * .45,
                                          child: Text(
                                            orderDetail['order']['tariff']
                                                        ['products_price'] ==
                                                    0
                                                ? "Взять с клиента: ${orderDetail['order']['tariff']['total_price']}₽\n$feature"
                                                : "Сумма выкупа: ${orderDetail['order']['tariff']['products_price']}₽\nВзять с клиента: ${orderDetail['order']['tariff']['products_price'] + orderDetail['order']['tariff']['total_price']}₽\n$feature",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * .4,
                                          child: Text(
                                            "Ваш заработок: $guarantPrice₽\n",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                  child: StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setButtonState) {
                                    return FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(4.0)),
                                      ),
                                      onPressed: () async {
                                        if (deliverStatus == "order_start") {
                                          statusCode = await getStatusOrder(
                                              'on_place',
                                              orderDetail['offer']['uuid'],
                                              null,
                                              0);
                                          if (statusCode == 200) {
                                            await deliverInitData();
                                            await getStatusOrder(
                                                'on_the_way',
                                                orderDetail['offer']['uuid'],
                                                null,
                                                null);
                                            setState(() async {
                                              await deliverInitData();
                                              clientVisibility = true;
                                              switchToClient = (orderDetail['order']
                                                          ['client']['comment'])
                                                      .contains(new RegExp(
                                                          r'[A-Za-z0-9а-яА-Я]'))
                                                  ? "Комментарий клиента:"
                                                  : switchToClient;
                                              orderComment = (orderDetail['order']
                                                          ['client']['comment'])
                                                      .contains(new RegExp(
                                                          r'[A-Za-z0-9а-яА-Я]'))
                                                  ? orderDetail['order']['client']
                                                      ['comment']
                                                  : null;
                                              buttonStatus = 'ПРИБЫЛ К КЛИЕНТУ';
                                            });
                                          } else if (statusCode == 406) {
                                            createAlertDialog(context, 'on_place',
                                                message, "ПРИБЫЛ К КЛИЕНТУ");
                                            await deliverInitData();
                                            setState(() async {
                                              await deliverInitData();
                                              switchToClient = (orderDetail['order']
                                                          ['client']['comment'])
                                                      .contains(new RegExp(
                                                          r'[A-Za-z0-9а-яА-Я]'))
                                                  ? "Комментарий клиента:"
                                                  : switchToClient;
                                              orderComment = (orderDetail['order']
                                                          ['client']['comment'])
                                                      .contains(new RegExp(
                                                          r'[A-Za-z0-9а-яА-Я]'))
                                                  ? orderDetail['order']['client']
                                                      ['comment']
                                                  : null;
                                              clientVisibility = true;
                                            });
                                          }
                                        }
                                        if (deliverStatus == 'on_the_way') {
                                          statusCode = await getStatusOrder(
                                              'order_payment',
                                              orderDetail['offer']['uuid'],
                                              null,
                                              null);
                                          if (statusCode == 200) {
                                            await deliverInitData();
                                            setState(() {
                                              deliverStatus = initData['order_data']
                                                  ['order_state']['value'];
                                              buttonStatus = 'ОТДАЛ ЗАКАЗ';
                                            });
                                          } else if (statusCode == 406) {
                                            createAlertDialog(
                                                context,
                                                'order_payment',
                                                message,
                                                'ОТДАЛ ЗАКАЗ');
                                            await deliverInitData();
                                            setState(() async {
                                              await deliverInitData();
                                            });
                                          }
                                        }
                                        if (deliverStatus == "order_payment") {
                                          await getStatusOrder(
                                              'finished',
                                              orderDetail['offer']['uuid'],
                                              null,
                                              null);
                                          Navigator.pop(context);
                                        }
                                        if (deliverStatus == null) {
                                          setState(() {
                                            phoneVisibility = true;
                                          });
                                          await updateRefreshToken(
                                              sharedPreferences.get('refToken'));
                                          var assignCode = await assignOrder(
                                              orderDetail['offer']['uuid']);
                                          if (assignCode == 200) {
                                            var statusCode = await getStatusOrder(
                                                'offer_offered',
                                                orderDetail['offer']['uuid'],
                                                null,
                                                null);
                                            if (statusCode == 200) {
                                              var initCode = await deliverInitData();
                                              if (initCode == 200) {
                                                int currentTimeUnix = (DateTime.now()
                                                            .millisecondsSinceEpoch /
                                                        1000)
                                                    .round();
                                                arrivalTime =
                                                    ((arrivalTimeToFirstPoint +
                                                            currentTimeUnix))
                                                        .round();
                                                buttonIndex = 2;
                                                return showModalBottomSheet(
                                                    context: context,
                                                    backgroundColor: Colors.white,
                                                    builder: (context) {
                                                      return StatefulBuilder(builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setModalState) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  top: 8.0),
                                                          child: Container(
                                                            height:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .height *
                                                                    .275,
                                                            child: Visibility(
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(8.0),
                                                                    child: Wrap(
                                                                      direction: Axis.horizontal,
                                                                      children: List.generate(5, (index) {
                                                                        return Container(
                                                                          width: MediaQuery.of(context).size.width * .16,
                                                                          height: MediaQuery.of(context).size.width * .16,
                                                                          margin: EdgeInsets.symmetric(
                                                                              horizontal:
                                                                                  4.0),
                                                                          child:
                                                                              FlatButton(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.all(Radius.circular(4.0)),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              setModalState(
                                                                                  () {
                                                                                arrivalTime = ((arrivalTimeToFirstPoint * coef[index] + currentTimeUnix)).round();
                                                                                buttonIndex = index;
                                                                                print("B $buttonIndex");
                                                                              });
                                                                              print("arrivalTime $arrivalTime");
                                                                            },
                                                                            child: Text("${((arrivalTimeToFirstPoint * coef[index]) / 60).round()}",
                                                                              style: TextStyle(
                                                                                color: buttonIndex != index
                                                                                    ? Colors.black
                                                                                    : Color(0xFFFD6F6D),
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: fondTimeSize,
                                                                              ),
                                                                            ),
                                                                            color: Color(0xFFEEEEEE),
                                                                          ),
                                                                        );
                                                                      }),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0),
                                                                    child: Container(
                                                                      child: ButtonAnimation(
                                                                          primaryColor:
                                                                              Color(
                                                                                  0xFFFD6F6D),
                                                                          darkPrimaryColor:
                                                                              Color(
                                                                                  0xFF33353E),
                                                                          orderFunction:
                                                                              onStartOrder),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 8.0,
                                                                      left: 24.0,
                                                                      right: 24.0,
                                                                    ),
                                                                    child: Container(
                                                                      child: Text(
                                                                          "Пожалуйста, укажите максимально точное время прибытия к клиенту"),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
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
                                  }),
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
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                bottom: PreferredSize(
                    child: Container(
                      color: Color(0xFFECEEEC),
                      height: 1.0,
                    ),
                    preferredSize: Size.fromHeight(1.0)),
                elevation: 0.0,
                title: ListTile(
                  title: Transform(
                    transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
                    child: Text(
                      "Заказ",
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "UniNeue",
                      ),
                    ),
                  ),
                  subtitle: Transform(
                    transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
                    child: Text(
                      "$formattedDate-$currentId",
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    if (initData['order_data']['offer']['uuid'] != null) {
                      await getStatusOrder("offer_rejected",
                          initData['order_data']['offer']['uuid'], null, null);
                    }
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
                          sharedPreferences = await SharedPreferences.getInstance();
                          setState(() {
                            isSwitched = value;
                          });
                          if (isSwitched) {
                            await updateRefreshToken(
                                sharedPreferences.get('refToken'));
                            await switchDeliverStatus("online");
                            setState(() {
                              opacity = 1;
                            });
                          } else {
                            await updateRefreshToken(
                                sharedPreferences.get('refToken'));
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
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
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
                                              "Доставка из $category",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFFFD6F6D),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // Visibility(
                                            //   visible: phoneVisibility,
                                            //   child: Text(
                                            //     "(Время прибытия)",
                                            //     style: TextStyle(
                                            //       fontSize: 14.0,
                                            //       color: Colors.black,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),
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
                                            border:
                                            Border.all(color: Color(0xFFFD6F6D)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0, horizontal: 20.0),
                                            child: Text(
                                              (initData['order_data']['order']['tariff']
                                              ['payment_type'])
                                                  .toUpperCase(),
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
                              ),
                              Divider(
                                color: Color(0xFFECEEEC),
                              ),
                              Container(
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Container(
                                              width: 18.0,
                                              height: 19.0,
                                              child: Image.asset(
                                                "images/icons/restaurant_icon.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${initData['order_data']['order']['routes'][0]['value']}",
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
                                          "${initData['order_data']['order']['routes'][0]['street']}, ${initData['order_data']['order']['routes'][0]['house']} • ${(initData['order_data']['offer']['route_to_client']['properties']['distance'] / 1000).toStringAsFixed(1)}км от вас",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: (16.0),
                                            fontFamily: 'UniNeue',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Container(
                                        //   width: 17.0,
                                        //   height: 15.0,
                                        //   child: ConstrainedBox(
                                        //     constraints: BoxConstraints.expand(),
                                        //     child: Ink.image(
                                        //       image: AssetImage('images/icons/map_icon.png'),
                                        //       fit: BoxFit.fill,
                                        //       child: InkWell(
                                        //         onTap: () {
                                        //           Navigator.of(context)
                                        //               .push(MaterialPageRoute(
                                        //             builder: (context) => MapScreen(
                                        //                 orderDetail['order']['routes'][0]
                                        //                 ['lat'],
                                        //                 orderDetail['order']['routes'][0]
                                        //                 ['lon']),
                                        //           ));
                                        //         },
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
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
                                visible: true,
                                child: Container(
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.person_outline),
                                            ),
                                            Text(
                                              (initData['order_data']['order']['routes']).length > 1 ? initData['order_data']['order']['routes'][1]['value'] : "",
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            (initData['order_data']['order']['routes']).length > 1
                                                ? "${initData['order_data']['order']['routes'][1]['street']}, ${initData['order_data']['order']['routes'][1]['house']} • ${((initData['order_data']['order']['route_way_data']['routes']['properties']['distance']) / 1000).toStringAsFixed(1)}км от вас"
                                                : "",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: (16.0),
                                              fontFamily: 'UniNeue',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Container(
                                          //   width: 17.0,
                                          //   height: 15.0,
                                          //   child: ConstrainedBox(
                                          //     constraints: BoxConstraints.expand(),
                                          //     child: Ink.image(
                                          //       image: AssetImage('images/icons/map_icon.png'),
                                          //       fit: BoxFit.fill,
                                          //       child: InkWell(
                                          //         onTap: () {
                                          //           Navigator.of(context)
                                          //               .push(MaterialPageRoute(
                                          //             builder: (context) => MapScreen(
                                          //                 orderDetail['order']['routes'][1]
                                          //                 ['lat'],
                                          //                 orderDetail['order']['routes'][1]
                                          //                 ['lon']),
                                          //           ));
                                          //         },
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
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
                                                    onPressed: () async {
                                                      await callClient();
                                                    },
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
                              // Visibility(
                              //   visible: clientVisibility,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 16.0),
                              //     child: Divider(
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              Visibility(
                                visible: orderComment != null ? true : false,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Container(
                                    child: ListTile(
                                      title: Text(
                                        switchToClient,
                                        style: TextStyle(
                                          color: Color(0xFFB8BAB8),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        orderComment != null ? orderComment : "",
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
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            "СОСТАВ ЗАКАЗА:",
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
                                                  "${initData['order_data']['order']['products_data']['products'][index]['number']} x ${initData['order_data']['order']['products_data']['products'][index]['name']}",
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
                                padding: const EdgeInsets.only(bottom: 16.0),
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
                                    subtitle: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                          MediaQuery.of(context).size.width * .45,
                                          child: Text(
                                            initData['order_data']['order']['tariff']
                                            ['products_price'] ==
                                                0
                                                ? "Взять с клиента: ${initData['order_data']['order']['tariff']['total_price']}₽\n$feature"
                                                : "Сумма выкупа: ${initData['order_data']['order']['tariff']['products_price']}₽\nВзять с клиента: ${initData['order_data']['order']['tariff']['products_price'] + initData['order_data']['order']['tariff']['total_price']}₽\n$feature",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * .4,
                                          child: Text(
                                            "Ваш заработок: $guarantPrice₽\n",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                  child: StatefulBuilder(builder:
                                      (BuildContext context,
                                      StateSetter setButtonState) {
                                    return FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                      ),
                                      onPressed: () async {
                                        if (deliverStatus == "order_start") {
                                          statusCode = await getStatusOrder(
                                              'on_place',
                                              initData['order_data']['offer']['uuid'],
                                              null,
                                              0);
                                          if (statusCode == 200) {
                                            await deliverInitData();
                                            await getStatusOrder(
                                                'on_the_way',
                                                initData['order_data']['offer']['uuid'],
                                                null,
                                                null);
                                            setState(() async {
                                              await deliverInitData();
                                              clientVisibility = true;
                                              switchToClient = (initData['order_data']['order']
                                              ['client']['comment'])
                                                  .contains(new RegExp(
                                                  r'[A-Za-z0-9а-яА-Я]'))
                                                  ? "Комментарий клиента:"
                                                  : switchToClient;
                                              orderComment = (initData['order_data']['order']
                                              ['client']['comment'])
                                                  .contains(new RegExp(
                                                  r'[A-Za-z0-9а-яА-Я]'))
                                                  ? initData['order_data']['order']['client']
                                              ['comment']
                                                  : null;
                                              buttonStatus = 'ПРИБЫЛ К КЛИЕНТУ';
                                            });
                                          } else if (statusCode == 406) {
                                            createAlertDialog(context, 'on_place',
                                                message, "ПРИБЫЛ К КЛИЕНТУ");
                                            await deliverInitData();
                                            setState(() async {
                                              await deliverInitData();
                                              switchToClient = (initData['order_data']['order']
                                              ['client']['comment'])
                                                  .contains(new RegExp(
                                                  r'[A-Za-z0-9а-яА-Я]'))
                                                  ? "Комментарий клиента:"
                                                  : switchToClient;
                                              orderComment = (initData['order_data']['order']
                                              ['client']['comment'])
                                                  .contains(new RegExp(
                                                  r'[A-Za-z0-9а-яА-Я]'))
                                                  ? initData['order_data']['order']['client']
                                              ['comment']
                                                  : null;
                                              clientVisibility = true;
                                            });
                                          }
                                        }
                                        if (deliverStatus == 'on_the_way') {
                                          statusCode = await getStatusOrder(
                                              'order_payment',
                                              initData['order_data']['offer']['uuid'],
                                              null,
                                              null);
                                          if (statusCode == 200) {
                                            await deliverInitData();
                                            setState(() {
                                              deliverStatus = initData['order_data']['order_data']
                                              ['order_state']['value'];
                                              buttonStatus = 'ОТДАЛ ЗАКАЗ';
                                            });
                                          } else if (statusCode == 406) {
                                            createAlertDialog(
                                                context,
                                                'order_payment',
                                                message,
                                                'ОТДАЛ ЗАКАЗ');
                                            await deliverInitData();
                                            setState(() async {
                                              await deliverInitData();
                                            });
                                          }
                                        }
                                        if (deliverStatus == "order_payment") {
                                          await getStatusOrder(
                                              'finished',
                                              initData['order_data']['offer']['uuid'],
                                              null,
                                              null);
                                          Navigator.pop(context);
                                        }
                                        if (deliverStatus == null) {
                                          setState(() {
                                            phoneVisibility = true;
                                          });
                                          await updateRefreshToken(
                                              sharedPreferences.get('refToken'));
                                          var assignCode = await assignOrder(
                                              initData['order_data']['offer']['uuid']);
                                          if (assignCode == 200) {
                                            var statusCode = await getStatusOrder(
                                                'offer_offered',
                                                initData['order_data']['offer']['uuid'],
                                                null,
                                                null);
                                            if (statusCode == 200) {
                                              var initCode = await deliverInitData();
                                              if (initCode == 200) {
                                                int currentTimeUnix = (DateTime.now()
                                                    .millisecondsSinceEpoch /
                                                    1000)
                                                    .round();
                                                arrivalTime =
                                                    ((arrivalTimeToFirstPoint +
                                                        currentTimeUnix))
                                                        .round();
                                                buttonIndex = 2;
                                                return showModalBottomSheet(
                                                    context: context,
                                                    backgroundColor: Colors.white,
                                                    builder: (context) {
                                                      return StatefulBuilder(builder:
                                                          (BuildContext context,
                                                          StateSetter
                                                          setModalState) {
                                                        return Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                          child: Container(
                                                            height:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                                .275,
                                                            child: Visibility(
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(8.0),
                                                                    child: Wrap(
                                                                      direction: Axis.horizontal,
                                                                      children: List.generate(5, (index) {
                                                                        return Container(
                                                                          width: MediaQuery.of(context).size.width * .16,
                                                                          height: MediaQuery.of(context).size.width * .16,
                                                                          margin: EdgeInsets.symmetric(
                                                                              horizontal:
                                                                              4.0),
                                                                          child:
                                                                          FlatButton(
                                                                            shape:
                                                                            RoundedRectangleBorder(
                                                                              borderRadius:
                                                                              BorderRadius.all(Radius.circular(4.0)),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              setModalState(
                                                                                      () {
                                                                                    arrivalTime = ((arrivalTimeToFirstPoint * coef[index] + currentTimeUnix)).round();
                                                                                    buttonIndex = index;
                                                                                    print("B $buttonIndex");
                                                                                  });
                                                                              print("arrivalTime $arrivalTime");
                                                                            },
                                                                            child: Text("${((arrivalTimeToFirstPoint * coef[index]) / 60).round()}",
                                                                              style: TextStyle(
                                                                                color: buttonIndex != index
                                                                                    ? Colors.black
                                                                                    : Color(0xFFFD6F6D),
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: fondTimeSize,
                                                                              ),
                                                                            ),
                                                                            color: Color(0xFFEEEEEE),
                                                                          ),
                                                                        );
                                                                      }),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0),
                                                                    child: Container(
                                                                      child: ButtonAnimation(
                                                                          primaryColor:
                                                                          Color(
                                                                              0xFFFD6F6D),
                                                                          darkPrimaryColor:
                                                                          Color(
                                                                              0xFF33353E),
                                                                          orderFunction:
                                                                          onStartOrder),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                      top: 8.0,
                                                                      left: 24.0,
                                                                      right: 24.0,
                                                                    ),
                                                                    child: Container(
                                                                      child: Text(
                                                                          "Пожалуйста, укажите максимально точное время прибытия к клиенту"),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
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
                                  }),
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
      ),
    );
  }
}
