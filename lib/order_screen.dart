import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:faem_delivery/animations/button_animation.dart';
import 'package:faem_delivery/deliveryJson/assign_order.dart';
import 'package:faem_delivery/deliveryJson/call_client.dart';
import 'package:faem_delivery/deliveryJson/deliver_verification.dart';
import 'package:faem_delivery/deliveryJson/get_free_order_detail.dart';
import 'package:faem_delivery/deliveryJson/get_init_data.dart';
import 'package:faem_delivery/deliveryJson/update_status.dart';
import 'package:faem_delivery/taxi_menu.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'Internet/check_connection.dart';
import 'Internet/show_pop_up.dart';
import 'deliveryJson/get_orders.dart';
import 'deliveryJson/send_location.dart';
import 'deliveryJson/switch_deliver_status.dart';
import 'main.dart';
import 'package:map_launcher/map_launcher.dart';

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
  var dataUse;
  var connectivity;
  double opacity = 1.0;
  bool switchEnable = false;
  StreamSubscription<ConnectivityResult> subscription;

  onStartOrder(newStatus) {
    setState(() {
      buttonStatus = newStatus;
    });
  }

  getData(dataUse) {
    var statusCode;
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
              if (dataUse['offer']['uuid'] != null && (orderValue == null || orderValue == 'offer_offered')) {
                //print("${dataUse['offer']['uuid']}");
                await getStatusOrder("offer_rejected", dataUse['offer']['uuid'], null, null);
                Navigator.pop(context);
              }
          },
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  if (this.mounted) {
                    setState(() => _switchValue = !_switchValue);
                  }
                },
                child: AbsorbPointer(
                  absorbing: switchEnable,
                  ignoringSemantics: switchEnable,
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) async {
                        if (await Internet.checkConnection()) {
                          if(opacity != 1) {
                            setState(() {
                              opacity = 1;
                              isSwitched = true;
                            });
                          }
                          if (this.mounted && deliverStatus == null) {
                            setState(() {
                               switchEnable = false;
                            });
                            if (isSwitched == false) {
                              setState(() {
                                isSwitched = true;
                              });
                            } else {
                              isSwitched = isSwitched;
                            }
                            if (isSwitched) {
                              await sendLocation();
                              await switchDeliverStatus("online");
                              if (this.mounted) {
                                setState(() {
                                  opacity = 1;
                                });
                              }
                            } else {
                              await switchDeliverStatus("offline");
                              if (this.mounted) {
                                setState(() {
                                  opacity = 0.5;
                                });
                              }
                            }
                          } else {
                            setState(() {
                              switchEnable = true;
                            });
                            PopUp.showInternetDialog('Во время выполнения заказа, вы не можете перейти в оффлайн');
                          }
                        } else {
                          setState(() {
                            isSwitched = false;
                            opacity = 0.5;
                          });
                          PopUp.showInternetDialog('Ошибка подключения к интернету!\nПроверьте ваше интернет-соединение!');
                        }
                    },
                    inactiveTrackColor: Color(0xFFFF8064),
                    activeTrackColor: Color(0xFFAFE14C),
                    activeColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: AbsorbPointer(
        absorbing: !connectResult,
        ignoringSemantics: !connectResult,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(milliseconds: 250),
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: MediaQuery.of(context).size.height * 1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    "Доставка из $category",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFFFD6F6D),
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                        dataUse['order'] != null ? (dataUse['order']['tariff']['payment_type']).toUpperCase() : '',
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
                      ),
                      Divider(
                        color: Color(0xFFECEEEC),
                      ),
                      Container(
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        width: 18.0,
                                        height: 19.0,
                                        child: Image.asset(
                                          "images/icons/restaurant_icon.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${dataUse['order'] != null ? dataUse['order']['routes'][0]['value'] : ''}",
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              height: 1.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "UniNeue",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          subtitle: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(dataUse['order'] != null ?
                                  "${dataUse['order']['routes'][0]['street']}, ${dataUse['order']['routes'][0]['house']} • ${(dataUse['offer']['route_to_client']['properties']['distance'] / 1000).toStringAsFixed(1)}км от вас" : '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: (16.0),
                                    fontFamily: 'UniNeue',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 17.0,
                                  height: 15.0,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints.expand(),
                                    child: Ink.image(
                                      image: AssetImage(
                                          'images/icons/map_icon.png'),
                                      fit: BoxFit.fill,
                                      child: InkWell(
                                        onTap: () async {
                                          final availableMaps =
                                              await MapLauncher.installedMaps;
                                          //print(availableMaps);
                                          await availableMaps.first.showMarker(
                                            coords: Coords(
                                                dataUse['order']['routes'][0]['lat'],
                                                dataUse['order']['routes'][0]['lon']),
                                            title: dataUse['order']['routes'][0]['value'],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
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
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(Icons.person_outline),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (dataUse['order']['routes']).length > 1 && dataUse['order'] != null
                                                   ? dataUse['order']['routes'][1]['value'] : "",
                                              style: TextStyle(
                                                fontSize: 24.0,
                                                height: 1.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "UniNeue",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            subtitle: Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width *
                                        0.8,
                                    child: Text(
                                      (dataUse['order']['routes']).length > 1
                                          ? "${dataUse['order']['routes'][1]['street']}, ${dataUse['order']['routes'][1]['house']} • ${((dataUse['order']['route_way_data']['routes']['properties']['distance']) / 1000).toStringAsFixed(1)}км от вас"
                                          : "",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: (16.0),
                                        fontFamily: 'UniNeue',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 17.0,
                                    height: 15.0,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.expand(),
                                      child: Ink.image(
                                        image: AssetImage(
                                            'images/icons/map_icon.png'),
                                        fit: BoxFit.fill,
                                        child: InkWell(
                                          onTap: () async {
                                            final availableMaps =
                                                await MapLauncher.installedMaps;
                                            //print(availableMaps);
                                            await availableMaps.first
                                                .showMarker(
                                              coords: Coords(
                                                  dataUse['order']['routes'][1]
                                                      ['lat'],
                                                  dataUse['order']['routes'][1]
                                                      ['lon']),
                                              title: dataUse['order']['routes']
                                                  [1]['value'],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
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
                                              bool okCall = await callClient();
                                              if (okCall) {
                                                PopUp.showInternetDialog('Соединяю вас с клиентом\nОжидайте...');
                                              } else {
                                                PopUp.showInternetDialog('Попытка соедить вас с клиентом провалилась\nПопробуйте снова через минуту...');
                                              }
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
                                          "${dataUse['order']['products_data']['products'][index]['number']} x ${dataUse['order']['products_data']['products'][index]['name']}",
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
                                    dataUse['order']['tariff']['products_price'] == 0
                                        ? "Взять с клиента: ${dataUse['order']['tariff']['total_price'] - dataUse['order']['tariff']['bonus_payment']}₽\n\n$feature"
                                        : "Сумма выкупа: ${dataUse['order']['tariff']['products_price']}₽\nВзять с клиента: ${dataUse['order']['tariff']['products_price'] + dataUse['order']['tariff']['total_price'] - dataUse['order']['tariff']['bonus_payment']}₽\n\n$feature",
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
                                    "Ваш заработок: $guarantPrice₽\n\nПоступят на курьерский баланс: ${dataUse['order']['tariff']['bonus_payment']}₽",
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
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: StatefulBuilder(builder: (BuildContext context,
                              StateSetter setButtonState) {
                            return FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              onPressed: () async {
                                if (await Internet.checkConnection()) {
                                  if (opacity != 1) {
                                    setState(() {
                                      opacity = 1;
                                    });
                                  }
                                  if (deliverStatus == "order_start" ||
                                      deliverStatus == 'on_place') {
                                    statusCode = await getStatusOrder('on_place',
                                        dataUse['offer']['uuid'], null, 0);
                                    if (statusCode == 200) {
                                      await getStatusOrder('on_the_way',
                                          dataUse['offer']['uuid'], null, null);
                                      setState(()  {
                                        clientVisibility = true;
                                        switchToClient = (dataUse['order']['client']['comment']).contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
                                            ? "Комментарий клиента:"
                                            : switchToClient;
                                        orderComment = (dataUse['order']['client']['comment']).contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
                                            ? dataUse['order']['client']['comment'] : null;
                                        buttonStatus = 'ПРИБЫЛ К КЛИЕНТУ';
                                      });
                                    } else if (statusCode == 406) {
                                      createAlertDialog(context, 'on_place',
                                          message, "ПРИБЫЛ К КЛИЕНТУ", dataUse);
                                      setState(()  {
                                        switchToClient = (dataUse['order']
                                                    ['client']['comment'])
                                                .contains(new RegExp(
                                                    r'[A-Za-z0-9а-яА-Я]'))
                                            ? "Комментарий клиента:"
                                            : switchToClient;
                                        orderComment = (dataUse['order']['client']
                                                    ['comment'])
                                                .contains(new RegExp(
                                                    r'[A-Za-z0-9а-яА-Я]'))
                                            ? dataUse['order']['client']
                                                ['comment']
                                            : null;
                                        clientVisibility = true;
                                      });
                                    }
                                  }
                                  if (deliverStatus == 'on_the_way') {
                                    statusCode = await getStatusOrder('order_payment', dataUse['offer']['uuid'], null, null);
                                    if (statusCode == 200) {
                                      buttonStatus = 'ОТДАЛ ЗАКАЗ';
                                      setState(() {
                                        deniedCallVisibility = true;
                                      });
                                      // deliverStatus = dataUse['order_state']['value'];
                                    } else if (statusCode == 406) {
                                      createAlertDialog(context, 'order_payment',
                                          message, 'ОТДАЛ ЗАКАЗ', dataUse);
                                      setState(()  {
                                        deniedCallVisibility = true;
                                      });
                                    }
                                  }
                                  if (deliverStatus == "order_payment") {
                                    await getStatusOrder('finished', dataUse['offer']['uuid'], null, null);
                                    setState(() {
                                      deliverStatus = null;
                                    });
                                    Navigator.pop(context);
                                  }
                                  if (deliverStatus == null) {
                                    setState(() {
                                      phoneVisibility = true;
                                    });
                                    await updateRefreshToken(sharedPreferences.get('refToken'));
                                    if (deliverStatus != "finished") {
                                      var assignCode = await assignOrder(dataUse['offer']['uuid']);
                                      if (assignCode == 200) {
                                        var statusCode = await getStatusOrder('offer_offered', dataUse['offer']['uuid'], null, null);
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
                                                  return StatefulBuilder(builder:
                                                      (BuildContext context, StateSetter setModalState) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * .275,
                                                        child: Visibility(
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Wrap(
                                                                  direction: Axis.horizontal,
                                                                  children: List.generate(5, (index) {
                                                                    return Container(
                                                                      width: MediaQuery.of(context).size.width * .16,
                                                                      height: MediaQuery.of(context).size.width * .16,
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal: 4.0),
                                                                      child: FlatButton(
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                        ),
                                                                        onPressed: () async {
                                                                          if (await Internet.checkConnection()) {
                                                                            if (opacity != 1) {
                                                                              setState(() {
                                                                                opacity = 1;
                                                                              });
                                                                            }
                                                                            setModalState(() {
                                                                              if (((arrivalTimeToFirstPoint * coef[index]) / 60) < 1) {
                                                                                arrivalTime = ((arrivalTimeToFirstPoint * coef[index] + currentTimeUnix + 60 * (index + 1))).round();
                                                                                print(arrivalTime);
                                                                              } else {
                                                                                arrivalTime = ((arrivalTimeToFirstPoint * coef[index] + currentTimeUnix)).round();
                                                                                print(arrivalTime);
                                                                              }
                                                                              buttonIndex = index;
                                                                              //print("B $buttonIndex");
                                                                            });
                                                                          } else {
                                                                            setState(() {
                                                                              opacity = 0.5;
                                                                            });
                                                                            PopUp.showInternetDialog('Ошибка подключения к интернету!\nПроверьте ваше интернет-соединение!');
                                                                          }
                                                                          //print("arrivalTime $arrivalTime");
                                                                        },
                                                                        child: Text(
                                                                          ((arrivalTimeToFirstPoint * coef[index]) / 60).round() < 1 ? '${((arrivalTimeToFirstPoint * coef[index]) / 60).round() + index + 1}' : '${((arrivalTimeToFirstPoint * coef[index]) / 60).round()}',
                                                                          style: TextStyle(
                                                                            color: buttonIndex != index ? Colors.black : Color(0xFFFD6F6D),
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                fondTimeSize,
                                                                          ),
                                                                        ),
                                                                        color: Color(
                                                                            0xFFEEEEEE),
                                                                      ),
                                                                    );
                                                                  }),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                        left: 24.0,
                                                                        right: 24.0,
                                                                        top: 16.0),
                                                                child: Container(
                                                                  child: ButtonAnimation(
                                                                      primaryColor: Color(0xFFFD6F6D),
                                                                      darkPrimaryColor: Color(0xFF33353E),
                                                                      orderFunction: onStartOrder
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(
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
                                  }
                                } else {
                                  setState(() {
                                    opacity = 0.5;
                                  });
                                  PopUp.showInternetDialog('Ошибка подключения к интернету!\nПроверьте ваше интернет-соединение!');
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
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: FlatButton(
                              onPressed: () async {
                                if (await Internet.checkConnection()) {
                                  if (opacity != 1) {
                                    setState(() {
                                      opacity = 1;
                                    });
                                  }
                                  launchWhatsApp(phone: "+79891359399", message: "");
                                } else {
                                  setState(() {
                                    opacity = 0.5;
                                  });
                                  PopUp.showInternetDialog('Ошибка подключения к интернету!\nПроверьте ваше интернет-соединение!');
                                }
                              },
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

  getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
  }

  createAlertDialog(BuildContext context, String status, String mes, String buttonState, alertData) {
    //print(message);
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
              if (await Internet.checkConnection()) {
                if(opacity != 1) {
                  setState(() {
                    opacity = 1;
                  });
                }
                var answer = await getStatusOrder(status, alertData['offer']['uuid'], null, distance);
                if (answer == 200) {
                  if (status == "on_place") {
                    await getStatusOrder('on_the_way', alertData['offer']['uuid'], null, distance);
                    setState(() {
                      buttonStatus = buttonState;
                    });
                  } else {
                    //print("buttonState $buttonState");
                    await getStatusOrder('order_payment',
                        alertData['offer']['uuid'], null, distance);
                    setState(() {
                      buttonStatus = buttonState;
                    });
                  }
                  Navigator.pop(context);
                }
              } else {
                setState(() {
                  opacity = 0.5;
                });
                PopUp.showInternetDialog('Ошибка подключения к интернету!\nПроверьте ваше интернет-соединение!');
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
      text: initData['order_data'] == null
          ? orderDetail['order']['client']['main_phone']
          : initData['order_data']['order']['client']['main_phone']);

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
  bool _switchValue;

  getInitData(dataUse) {
    //print('ORDER STATUS: $deliverStatus');
    String orderId = dataUse['order']['uuid'];
    currentId = orderId.substring(orderId.length - 4);
    //print(currentId);
    if (dataUse['order_state'] != null) {
      deliverStatus = dataUse['order_state']['value'];
    }
    if (dataUse['order']['tariff']['total_price'] <
        dataUse['order']['tariff']['guaranteed_driver_income']) {
      guarantPrice = dataUse['order']['tariff']['guaranteed_driver_income'];
    } else {
      guarantPrice = dataUse['order']['tariff']['total_price'];
    }
    clientVisibility = false;
    phoneVisibility = true;
    buttonIndex = 2;
    if (dataUse['order']['routes'][0]['category'] == 'Рестораны') {
      category = 'ресторана';
    } else if (dataUse['order']['routes'][0]['category'] == 'Аптеки') {
      category = 'аптеки';
    } else if (dataUse['order']['routes'][0]['category'] == 'Магазины') {
      category = 'магазина';
    } else {
      category = 'заведения';
    }
    //print("ORDER: ${(dataUse['order'])}");
    //print("features: ${(dataUse['order']['features'])}");
    if ((dataUse['order']['features']) == null ||
        (dataUse['order']['features']).isEmpty) {
      feature = '';
    } else {
      feature = dataUse['order']['features'][0]['name'];
    }
    switch (deliverStatus) {
      case 'order_start':
        {
          switchToClient = 'Комментрарий ресторана';
          orderComment = (dataUse['order']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? dataUse['order']['comment']
              : null;
          buttonStatus = 'ПРИБЫЛ К ЗАВЕДЕНИЮ';
        }
        break;
      case 'on_place':
        {
          switchToClient = (dataUse['order']['client']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? "Комментарий клиента:"
              : switchToClient;
          orderComment = (dataUse['order']['client']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? dataUse['order']['client']['comment']
              : null;
          buttonStatus = 'ПРИБЫЛ К КЛИЕНТУ';
          clientVisibility = true;
        }
        break;
      case 'on_the_way':
        {
          switchToClient = (dataUse['order']['client']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? "Комментарий клиента:"
              : switchToClient;
          orderComment = (dataUse['order']['client']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? dataUse['order']['client']['comment']
              : null;
          buttonStatus = 'ПРИБЫЛ К КЛИЕНТУ';
        }
        break;
      case 'order_payment':
        {
          switchToClient = (dataUse['order']['client']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? "Комментарий клиента:"
              : switchToClient;
          orderComment = (dataUse['order']['client']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? dataUse['order']['client']['comment']
              : null;
          buttonStatus = 'ОТДАЛ ЗАКАЗ';
          setState(() {
            deniedCallVisibility = true;
          });
        }
        break;
      default:
        {
          switchToClient = 'Комментрарий ресторана';
          orderComment = (dataUse['order']['comment'])
              .contains(new RegExp(r'[A-Za-z0-9а-яА-Я]'))
              ? dataUse['order']['comment']
              : null;
          buttonStatus = "ПРИНЯТЬ ЗАКАЗ";
        }
        break;
    }
  }

  @override
  void initState() {
    orderValue = null;
    deniedCallVisibility = false;
    if (initData['order_data'] == null) {
      getInitData(orderDetail);
    } else {
      getInitData(initData['order_data']);
    }
    //print('feature $feature');
    switchToClient = "Комментарий ресторана:";
    super.initState();
    _switchValue = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (orderDetail['offer']['uuid'] != null) {
          await getStatusOrder(
              "offer_rejected", orderDetail['offer']['uuid'], null, null);
        }
        Navigator.pop(context);
        return null;
      },
      child: FutureBuilder(
          future: deliverInitData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (initData['order_data'] == null && snapshot.hasData) {
              if (orders != null) {
                return getData(orderDetail);
              } else {
                return Scaffold(
                  body: Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
            } else if (snapshot.hasData && initData['order_data'] != null) {
              return getData(initData['order_data']);
            } else {
              return Scaffold(
                body: Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          },
      ),
    );
  }
}
