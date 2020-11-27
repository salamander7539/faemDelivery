import 'package:faem_delivery/deliveryJson/get_driver_data.dart';
import 'package:faem_delivery/deliveryJson/get_history_data.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'deliveryJson/DriverData.dart';
import 'deliveryJson/deliver_verification.dart';
import 'deliveryJson/switch_deliver_status.dart';
import 'main.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {

  @override
  Widget build(BuildContext context) {
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
        leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            }
        ),
        title: Transform(
          transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
          child: Text(
            "Профиль курьера",
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
                      await updateRefreshToken(sharedPreferences.get('refToken'));
                      await switchDeliverStatus("online");
                    } else {
                      await updateRefreshToken(sharedPreferences.get('refToken'));
                      await switchDeliverStatus("offline");
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
      body: FutureBuilder<DriverData>(
        future: getDriverData(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<DriverData> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      leading: Transform(
                        transform:
                        Matrix4.translationValues(
                            -25.0, 0.0, 0.0),
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
                          snapshot.data.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                        ),
                      ),
                      subtitle: Transform(
                        transform:
                        Matrix4.translationValues(
                            -50.0, 0.0, 0.0),
                        child: Text(
                          'Баланс: ${snapshot.data.balance} ₽',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Color(0xFF9D9C97)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Container(
                            child: ListTile(
                              title: Text(
                                'Ваш рейтинг',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                              ),
                              subtitle: Text(
                                'Средняя оценка клиентов',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Color(0xFF9D9C97)),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.white,
                            child: Container(
                              margin: EdgeInsets.only(left: 4.0, right: 12.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF9D9C97),
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 18.0,
                                      color: Color(0xFF9D9C97),
                                    ),
                                    Text(
                                      "${snapshot.data.karma}.0",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9D9C97), fontSize: 13.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Container(
                            child: ListTile(
                              title: Text(
                                'История заказов',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                              ),
                              subtitle: Text(
                                'Доставки за день',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Color(0xFF9D9C97)),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.white,
                            child: Container(
                              margin: EdgeInsets.only(right: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFF9D9C97),
                                    width: 1
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                child: Text(
                                  countOfOrders == null ? '0' : "$countOfOrders",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9D9C97), fontSize: 14.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Divider(color: Color(0xFFECEEEC),),
                  // Container(
                  //   child: ListTile(
                  //     title: Container(
                  //       margin: EdgeInsets.only(bottom: 2.0,),
                  //       child: Text(
                  //         "Полное имя",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.black,
                  //             fontSize: 12.0),
                  //       ),
                  //     ),
                  //     subtitle: Container(
                  //       height: 38.0,
                  //       child: TextField(
                  //         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF5A5A5A)),
                  //         textAlignVertical: TextAlignVertical.center,
                  //         textAlign: TextAlign.justify,
                  //         onChanged: (String newFio) async {
                  //           fio = newFio;
                  //         },
                  //         decoration: InputDecoration(
                  //           enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Color(0xFFECEEEC)),
                  //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  //           ),

                  //           focusedBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Color(0xFFECEEEC)),
                  //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  //           ),
                  //           // filled: true,
                  //           contentPadding: EdgeInsets.only(
                  //             bottom: 38.0 / 4,  // HERE THE IMPORTANT PART
                  //             left: 12.0,
                  //           ),
                  //           hintText: "ФИО",
                  //           hintStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF878A87)),
                  //           hoverColor: Color(0xFFECEEEC),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 16.0),
                  //   child: ListTile(
                  //     title: Container(
                  //       margin: EdgeInsets.only(bottom: 2.0,),
                  //       child: Text(
                  //         "Телефон",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.black,
                  //             fontSize: 12.0),
                  //       ),
                  //     ),
                  //     subtitle: Container(
                  //       height: 38.0,
                  //       child: TextField(
                  //         onChanged: (String newNumber) async {
                  //           number = newNumber;
                  //         },
                  //         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF5A5A5A)),
                  //         textAlignVertical: TextAlignVertical.center,
                  //         textAlign: TextAlign.justify,
                  //         decoration: InputDecoration(
                  //           enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Color(0xFFECEEEC)),
                  //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Color(0xFFECEEEC)),
                  //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  //           ),
                  //           // filled: true,
                  //           contentPadding: EdgeInsets.only(
                  //             bottom: 38.0 / 4,  // HERE THE IMPORTANT PART
                  //             left: 12.0,
                  //           ),
                  //           hintText: "+7 998 777 66 55",
                  //           hintStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF878A87)),
                  //           hoverColor: Color(0xFFECEEEC),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 16.0),
                  //   child: ListTile(
                  //     title: Container(
                  //       margin: EdgeInsets.only(bottom: 2.0,),
                  //       child: Text(
                  //         "Адрес регистрации",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.black,
                  //             fontSize: 12.0),
                  //       ),
                  //     ),
                  //     subtitle: Container(
                  //       height: 38.0,
                  //       child: TextField(
                  //         onChanged: (String newDeliverAddress) async {
                  //           deliverAddress = newDeliverAddress;
                  //         },
                  //         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF5A5A5A)),
                  //         textAlignVertical: TextAlignVertical.center,
                  //         textAlign: TextAlign.justify,
                  //         decoration: InputDecoration(
                  //           enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Color(0xFFECEEEC)),
                  //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Color(0xFFECEEEC)),
                  //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  //           ),
                  //           // filled: true,
                  //           contentPadding: EdgeInsets.only(
                  //             bottom: 38.0 / 4,  // HERE THE IMPORTANT PART
                  //             left: 12.0,
                  //           ),
                  //           hintText: "Владикавказ, ул. Московская, д.3",
                  //           hintStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF878A87)),
                  //           hoverColor: Color(0xFFECEEEC),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 16.0),
                  //   child: ListTile(
                  //     title: Container(
                  //       margin: EdgeInsets.only(bottom: 2.0,),
                  //       child: Text(
                  //         "Серия и номер паспорта",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.black,
                  //             fontSize: 12.0),
                  //       ),
                  //     ),
                  //     subtitle: Container(
                  //       height: 38.0,
                  //       child: TextField(
                  //         onChanged: (String newPassport) async {
                  //           passport = newPassport;
                  //         },
                  //         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF5A5A5A)),
                  //         textAlignVertical: TextAlignVertical.center,
                  //         textAlign: TextAlign.justify,
                  //         decoration: InputDecoration(
                  //           enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Color(0xFFECEEEC)),
                  //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Color(0xFFECEEEC)),
                  //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  //           ),
                  //           // filled: true,
                  //           contentPadding: EdgeInsets.only(
                  //             bottom: 38.0 / 4,  // HERE THE IMPORTANT PART
                  //             left: 12.0,
                  //           ),
                  //           hintText: "8008 847563",
                  //           hintStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF878A87)),
                  //           hoverColor: Color(0xFFECEEEC),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 16.0),
                  //   child: ListTile(
                  //     leading: Transform(
                  //       transform:
                  //       Matrix4.translationValues(
                  //           -10.0, 0.0, 0.0),
                  //       child: Stack(
                  //         children: [
                  //           IconButton(
                  //             icon: Image.asset(
                  //               'images/icons/file.png',
                  //               fit: BoxFit.fill,
                  //             ),
                  //             iconSize: 38.0,
                  //             onPressed: () {},
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     title: Transform(
                  //       transform:
                  //       Matrix4.translationValues(
                  //           -25.0, 0.0, 0.0),
                  //       child: Text(
                  //         'Загрузите фото паспорта',
                  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                  //       ),
                  //     ),
                  //     subtitle: Transform(
                  //       transform:
                  //       Matrix4.translationValues(
                  //           -25.0, 0.0, 0.0),
                  //       child: Text(
                  //         'Разворот с личными данными и адресом',
                  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Color(0xFF9D9C97)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(left: 18.0),
                  //   child: OutlineButton(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius:
                  //       BorderRadius.all(
                  //           Radius.circular(6.0),
                  //       ),
                  //     ),
                  //     color: Color(0xFFFAFAFA),
                  //     onPressed: () {},
                  //     child: Text(
                  //       'ОБНОВИТЬ ДАННЫЕ',
                  //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12.0),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
      ),
    );
  }
}
