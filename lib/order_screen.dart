import 'package:faem_delivery/deliveryJson/get_orders.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'deliveryJson/switch_deliver_status.dart';
import 'delivery_screen.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool phoneVisibility = false;
  bool deniedCallVisibility = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "№ Заказа",
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
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
                    isSwitched=value;
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
                                  "${orders[chosenIndex]['order']['routes'][0]['value']}",
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
                                "${orders[chosenIndex]['order']['routes'][0]['street']}, ${orders[chosenIndex]['order']['routes'][0]['house']}",
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
                                        "${orders[chosenIndex]['order']['client']['main_phone']}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 3.5),
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
                      visible: orders[chosenIndex]['order']['client']['comment'] != "" ? true : false,
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
                              "${orders[chosenIndex]['order']['client']['comment']}",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        child: ListTile(
                          title: Text(
                            "Состав заказа:",
                            style: TextStyle(
                              color: Color(0xFFB8BAB8),
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Nn kjfmvkmfvklfmv,nvnmknlkfdnvkfd vjfdnvjfdnvhjdfbnvkfdbvkjfdbvjhfdnvkjdbvksdnbv",
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
                            "Сумма по заказу: ${orders[chosenIndex]['order']['tariff']['total_price']}₽\nБезналичная оплата в ресторане\nБезналичная оплата клиентом\nБез сдачи клиенту",
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
                          child: RaisedButton(
                            onPressed: () async {
                              setState(() {
                                phoneVisibility = true;
                              });
                              await updateRefreshToken(newRefToken);
                              await getOrdersData();
                            },
                            color: Color(0xFFFD6F6D),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "ПРИНЯТЬ ЗАКАЗ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                            ),
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
