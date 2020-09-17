import 'package:faem_delivery/deliveryJson/get_history_data.dart';
import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:flutter/material.dart';

import 'deliveryJson/deliver_verification.dart';
import 'deliveryJson/get_free_order_detail.dart';
import 'deliveryJson/switch_deliver_status.dart';
import 'main.dart';
import 'package:intl/intl.dart';

class HistoryList extends StatefulWidget {
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
        title: Transform(
          transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
          child: Text(
            "История заказов",
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
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: getHistoryData(),
          // ignore: missing_return
          builder: (context, AsyncSnapshot snapshot) {
            if (countOfOrders > 0) {
              return ListView.builder(
                itemCount: countOfOrders == 0 ? 0 : countOfOrders,
                itemBuilder: (context, index) {
                  DateTime dateString = DateTime.parse(historyData['orders'][index]['created_at']);
                  var plusThreeHours = dateString.add(new Duration(hours: 3));
                  String cancelTime = DateFormat("hh:mm:ss").format(plusThreeHours);
                  return Container(
                    height: 77.0,
                    margin: EdgeInsets.only(top: 10.0, left: 17.0, right: 17.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFECEEEC)),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
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
                                "${historyData['orders'][index]['routes'][0]['value']}",
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
                              '${historyData['orders'][index]['routes'][0]['street']}, ${historyData['orders'][index]['routes'][0]['house']} • $cancelTime',
                              // "${historyData['order']['routes'][0]['street']}, ${historyData['order']['routes'][0]['house']} • ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: (16.0),
                                fontFamily: 'UniNeue',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                              child: Container(
                                width: 17.0,
                                height: 15.0,
                                child: Text(
                                  '${historyData['orders'][index]['tariff']['total_price']}₽',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
