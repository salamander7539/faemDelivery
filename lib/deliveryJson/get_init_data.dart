import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'deliver_verification.dart';
import 'get_free_order_detail.dart';

var initData;
var deliverStatus;
var distanceToFirstPoint, distanceToSecondPoint;
int responseTime, arrivalTimeToFirstPoint, arrivalTimeToSecondPoint, arrivalUnixToFirstPoint, arrivalUnixToSecondPoint = 0;

Future<int> deliverInitData() async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/initdata';
  var body = json.encode("");
  var response = await http.post(url, body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${sharedPreferences.get('token')}'
  });
  if (response.statusCode == 200) {
    initData = json.decode(response.body);
    //print('InitData: ${response.body}');
    if (initData['order_data'] != null) {
      var responseUnix = initData['order_data']['offer']['response_time'];
      arrivalTimeToFirstPoint = initData['order_data']['offer']['route_to_client']['properties']['duration'] - 1;
      distanceToFirstPoint = initData['order_data']['offer']['route_to_client']['properties']['distance'] - 1;
      //    print('distanceToFirstPoint: ${distanceToFirstPoint.round()}');
      distanceToSecondPoint = initData['order_data']['order']['route_way_data']['routes']['properties']['distance'];
      //    print('distanceToSecondPoint: ${distanceToSecondPoint.round()}');
      arrivalTimeToSecondPoint = initData['order_data']['order']['route_way_data']['routes']['properties']['duration'];
      if (initData['order_data']['order']['products_data'] != null) {
        products = initData['order_data']['order']['products_data']['products'];
      } else {
        products = initData['order_data']['order']['products_data'];
      }
      deliverStatus = initData['order_data']['order_state']['value'];
      print("deliverStatus: $deliverStatus");
      int currentUnix = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      responseTime = responseUnix - currentUnix;
      arrivalUnixToFirstPoint = currentUnix + arrivalTimeToFirstPoint;
    }
//    print('currentUnix $currentUnix');
//    print('arrivalUnixToFirstPoint $arrivalUnixToFirstPoint seconds');
//    print('responseTime $responseTime seconds');
//    print('arrivalTimeToFirstPoint $arrivalTimeToFirstPoint seconds');
//    print('arrivalTimeToSecondPoint $arrivalTimeToSecondPoint seconds');
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print(response.body);
  }
  print("getInit: ${response.statusCode}");
  return response.statusCode;
}
// To parse this JSON data, do
//
//     final deliverInitData = deliverInitDataFromJson(jsonString);

DeliverInitData deliverInitDataFromJson(String str) => DeliverInitData.fromJson(json.decode(str));

String deliverInitDataToJson(DeliverInitData data) => json.encode(data.toJson());

class DeliverInitData {
  DeliverInitData({
    this.driverUuid,
    this.alias,
    this.operatorPhone,
    this.driverState,
    this.webViewHost,
    this.photocontrolsData,
    this.orderData,
    this.balance,
  });

  final String driverUuid;
  final int alias;
  final String operatorPhone;
  final ErState driverState;
  final String webViewHost;
  final List<PhotocontrolsDatum> photocontrolsData;
  final OrderData orderData;
  final Balance balance;

  factory DeliverInitData.fromJson(Map<String, dynamic> json) => DeliverInitData(
    driverUuid: json["driver_uuid"],
    alias: json["alias"],
    operatorPhone: json["operator_phone"],
    driverState: ErState.fromJson(json["driver_state"]),
    webViewHost: json["web_view_host"],
    photocontrolsData: List<PhotocontrolsDatum>.from(json["photocontrols_data"].map((x) => PhotocontrolsDatum.fromJson(x))),
    orderData: OrderData.fromJson(json["order_data"]),
    balance: Balance.fromJson(json["balance"]),
  );

  Map<String, dynamic> toJson() => {
    "driver_uuid": driverUuid,
    "alias": alias,
    "operator_phone": operatorPhone,
    "driver_state": driverState.toJson(),
    "web_view_host": webViewHost,
    "photocontrols_data": List<dynamic>.from(photocontrolsData.map((x) => x.toJson())),
    "order_data": orderData.toJson(),
    "balance": balance.toJson(),
  };
}

class Balance {
  Balance({
    this.balance,
  });

  final int balance;

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
  };
}

class ErState {
  ErState({
    this.value,
    this.message,
  });

  final String value;
  final String message;

  factory ErState.fromJson(Map<String, dynamic> json) => ErState(
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
  };
}

class OrderData {
  OrderData({
    this.offer,
    this.order,
    this.taximeter,
    this.orderState,
    this.startTime,
  });

  final Offer offer;
  final Order order;
  final Taximeter taximeter;
  final ErState orderState;
  final int startTime;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    offer: Offer.fromJson(json["offer"]),
    order: Order.fromJson(json["order"]),
    taximeter: Taximeter.fromJson(json["taximeter"]),
    orderState: ErState.fromJson(json["order_state"]),
    startTime: json["start_time"],
  );

  Map<String, dynamic> toJson() => {
    "offer": offer.toJson(),
    "order": order.toJson(),
    "taximeter": taximeter.toJson(),
    "order_state": orderState.toJson(),
    "start_time": startTime,
  };
}

class Offer {
  Offer({
    this.uuid,
    this.driverUuid,
    this.orderUuid,
    this.offerType,
    this.responseTime,
    this.driverId,
    this.comment,
    this.tripTime,
    this.isFree,
    this.activity,
    this.routeToClient,
    this.arrivalTime,
  });

  final String uuid;
  final String driverUuid;
  final String orderUuid;
  final String offerType;
  final int responseTime;
  final int driverId;
  final String comment;
  final int tripTime;
  final bool isFree;
  final Activity activity;
  final RouteToClient routeToClient;
  final int arrivalTime;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    uuid: json["uuid"],
    driverUuid: json["driver_uuid"],
    orderUuid: json["order_uuid"],
    offerType: json["offer_type"],
    responseTime: json["response_time"],
    driverId: json["driver_id"],
    comment: json["comment"],
    tripTime: json["trip_time"],
    isFree: json["is_free"],
    activity: Activity.fromJson(json["activity"]),
    routeToClient: RouteToClient.fromJson(json["route_to_client"]),
    arrivalTime: json["arrival_time"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "driver_uuid": driverUuid,
    "order_uuid": orderUuid,
    "offer_type": offerType,
    "response_time": responseTime,
    "driver_id": driverId,
    "comment": comment,
    "trip_time": tripTime,
    "is_free": isFree,
    "activity": activity.toJson(),
    "route_to_client": routeToClient.toJson(),
    "arrival_time": arrivalTime,
  };
}

class Activity {
  Activity({
    this.accept,
    this.reject,
  });

  final int accept;
  final int reject;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    accept: json["accept"],
    reject: json["reject"],
  );

  Map<String, dynamic> toJson() => {
    "accept": accept,
    "reject": reject,
  };
}

class RouteToClient {
  RouteToClient({
    this.geometry,
    this.type,
    this.properties,
  });

  final RouteToClientGeometry geometry;
  final String type;
  final RouteToClientProperties properties;

  factory RouteToClient.fromJson(Map<String, dynamic> json) => RouteToClient(
    geometry: RouteToClientGeometry.fromJson(json["geometry"]),
    type: json["type"],
    properties: RouteToClientProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "geometry": geometry.toJson(),
    "type": type,
    "properties": properties.toJson(),
  };
}

class RouteToClientGeometry {
  RouteToClientGeometry({
    this.coordinates,
    this.type,
  });

  final List<List<double>> coordinates;
  final String type;

  factory RouteToClientGeometry.fromJson(Map<String, dynamic> json) => RouteToClientGeometry(
    coordinates: List<List<double>>.from(json["coordinates"].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "type": type,
  };
}

class RouteToClientProperties {
  RouteToClientProperties({
    this.duration,
    this.distance,
  });

  final int duration;
  final double distance;

  factory RouteToClientProperties.fromJson(Map<String, dynamic> json) => RouteToClientProperties(
    duration: json["duration"],
    distance: json["distance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "duration": duration,
    "distance": distance,
  };
}

class Order {
  Order({
    this.uuid,
    this.comment,
    this.routes,
    this.routeWayData,
    this.features,
    this.tariff,
    this.phoneLine,
    this.fixedPrice,
    this.service,
    this.increasedFare,
    this.driver,
    this.client,
    this.source,
    this.driverRating,
    this.clientRating,
    this.isOptional,
    this.withoutDelivery,
    this.orderStart,
    this.cancelTime,
    this.createdAt,
    this.distributionByTaxiPark,
    this.promotion,
    this.arrivalTime,
    this.productsData,
    this.callbackPhone,
    this.paymentType,
    this.paymentMeta,
    this.taxiParkData,
    this.taxiParkUuid,
  });

  final String uuid;
  final String comment;
  final List<Route> routes;
  final RouteWayData routeWayData;
  final List<dynamic> features;
  final OrderTariff tariff;
  final PhoneLine phoneLine;
  final int fixedPrice;
  final Service service;
  final int increasedFare;
  final Driver driver;
  final Client client;
  final String source;
  final Rating driverRating;
  final Rating clientRating;
  final bool isOptional;
  final bool withoutDelivery;
  final DateTime orderStart;
  final DateTime cancelTime;
  final DateTime createdAt;
  final bool distributionByTaxiPark;
  final OrderPromotion promotion;
  final int arrivalTime;
  final dynamic productsData;
  final String callbackPhone;
  final String paymentType;
  final PaymentMeta paymentMeta;
  final TaxiParkData taxiParkData;
  final String taxiParkUuid;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    uuid: json["uuid"],
    comment: json["comment"],
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
    routeWayData: RouteWayData.fromJson(json["route_way_data"]),
    features: List<dynamic>.from(json["features"].map((x) => x)),
    tariff: OrderTariff.fromJson(json["tariff"]),
    phoneLine: PhoneLine.fromJson(json["phone_line"]),
    fixedPrice: json["fixed_price"],
    service: Service.fromJson(json["service"]),
    increasedFare: json["increased_fare"],
    driver: Driver.fromJson(json["driver"]),
    client: Client.fromJson(json["client"]),
    source: json["source"],
    driverRating: Rating.fromJson(json["driver_rating"]),
    clientRating: Rating.fromJson(json["client_rating"]),
    isOptional: json["is_optional"],
    withoutDelivery: json["without_delivery"],
    orderStart: DateTime.parse(json["order_start"]),
    cancelTime: DateTime.parse(json["cancel_time"]),
    createdAt: DateTime.parse(json["created_at"]),
    distributionByTaxiPark: json["distribution_by_taxi_park"],
    promotion: OrderPromotion.fromJson(json["promotion"]),
    arrivalTime: json["arrival_time"],
    productsData: json["products_data"],
    callbackPhone: json["callback_phone"],
    paymentType: json["payment_type"],
    paymentMeta: PaymentMeta.fromJson(json["payment_meta"]),
    taxiParkData: TaxiParkData.fromJson(json["taxi_park_data"]),
    taxiParkUuid: json["taxi_park_uuid"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "comment": comment,
    "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
    "route_way_data": routeWayData.toJson(),
    "features": List<dynamic>.from(features.map((x) => x)),
    "tariff": tariff.toJson(),
    "phone_line": phoneLine.toJson(),
    "fixed_price": fixedPrice,
    "service": service.toJson(),
    "increased_fare": increasedFare,
    "driver": driver.toJson(),
    "client": client.toJson(),
    "source": source,
    "driver_rating": driverRating.toJson(),
    "client_rating": clientRating.toJson(),
    "is_optional": isOptional,
    "without_delivery": withoutDelivery,
    "order_start": orderStart.toIso8601String(),
    "cancel_time": cancelTime.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "distribution_by_taxi_park": distributionByTaxiPark,
    "promotion": promotion.toJson(),
    "arrival_time": arrivalTime,
    "products_data": productsData,
    "callback_phone": callbackPhone,
    "payment_type": paymentType,
    "payment_meta": paymentMeta.toJson(),
    "taxi_park_data": taxiParkData.toJson(),
    "taxi_park_uuid": taxiParkUuid,
  };
}

class Client {
  Client({
    this.uuid,
    this.name,
    this.karma,
    this.mainPhone,
    this.blocked,
    this.phones,
    this.deviceId,
    this.telegramId,
    this.comment,
    this.activity,
    this.defaultPaymentType,
    this.promotion,
    this.blacklist,
  });

  final String uuid;
  final String name;
  final int karma;
  final String mainPhone;
  final bool blocked;
  final dynamic phones;
  final String deviceId;
  final String telegramId;
  final String comment;
  final int activity;
  final String defaultPaymentType;
  final ClientPromotion promotion;
  final dynamic blacklist;

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    uuid: json["uuid"],
    name: json["name"],
    karma: json["karma"],
    mainPhone: json["main_phone"],
    blocked: json["blocked"],
    phones: json["phones"],
    deviceId: json["device_id"],
    telegramId: json["telegram_id"],
    comment: json["comment"],
    activity: json["activity"],
    defaultPaymentType: json["default_payment_type"],
    promotion: ClientPromotion.fromJson(json["promotion"]),
    blacklist: json["blacklist"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "karma": karma,
    "main_phone": mainPhone,
    "blocked": blocked,
    "phones": phones,
    "device_id": deviceId,
    "telegram_id": telegramId,
    "comment": comment,
    "activity": activity,
    "default_payment_type": defaultPaymentType,
    "promotion": promotion.toJson(),
    "blacklist": blacklist,
  };
}

class ClientPromotion {
  ClientPromotion({
    this.booster,
    this.isVip,
  });

  final bool booster;
  final bool isVip;

  factory ClientPromotion.fromJson(Map<String, dynamic> json) => ClientPromotion(
    booster: json["booster"],
    isVip: json["is_vip"],
  );

  Map<String, dynamic> toJson() => {
    "booster": booster,
    "is_vip": isVip,
  };
}

class Rating {
  Rating({
    this.value,
    this.comment,
  });

  final int value;
  final String comment;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    value: json["value"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "comment": comment,
  };
}

class Driver {
  Driver({
    this.uuid,
    this.name,
    this.paymentTypes,
    this.phone,
    this.comment,
    this.stateName,
    this.car,
    this.balance,
    this.karma,
    this.color,
    this.tariff,
    this.tag,
    this.availableServices,
    this.availableFeatures,
    this.alias,
    this.regNumber,
    this.activity,
    this.promotion,
    this.group,
    this.blacklist,
    this.taxiParkData,
    this.taxiParkUuid,
  });

  final String uuid;
  final String name;
  final dynamic paymentTypes;
  final String phone;
  final String comment;
  final String stateName;
  final String car;
  final int balance;
  final int karma;
  final String color;
  final DriverTariff tariff;
  final dynamic tag;
  final dynamic availableServices;
  final dynamic availableFeatures;
  final int alias;
  final String regNumber;
  final int activity;
  final DriverPromotion promotion;
  final Group group;
  final dynamic blacklist;
  final TaxiParkData taxiParkData;
  final dynamic taxiParkUuid;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    uuid: json["uuid"],
    name: json["name"],
    paymentTypes: json["payment_types"],
    phone: json["phone"],
    comment: json["comment"],
    stateName: json["state_name"],
    car: json["car"],
    balance: json["balance"],
    karma: json["karma"],
    color: json["color"],
    tariff: DriverTariff.fromJson(json["tariff"]),
    tag: json["tag"],
    availableServices: json["available_services"],
    availableFeatures: json["available_features"],
    alias: json["alias"],
    regNumber: json["reg_number"],
    activity: json["activity"],
    promotion: DriverPromotion.fromJson(json["promotion"]),
    group: Group.fromJson(json["group"]),
    blacklist: json["blacklist"],
    taxiParkData: TaxiParkData.fromJson(json["taxi_park_data"]),
    taxiParkUuid: json["taxi_park_uuid"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "payment_types": paymentTypes,
    "phone": phone,
    "comment": comment,
    "state_name": stateName,
    "car": car,
    "balance": balance,
    "karma": karma,
    "color": color,
    "tariff": tariff.toJson(),
    "tag": tag,
    "available_services": availableServices,
    "available_features": availableFeatures,
    "alias": alias,
    "reg_number": regNumber,
    "activity": activity,
    "promotion": promotion.toJson(),
    "group": group.toJson(),
    "blacklist": blacklist,
    "taxi_park_data": taxiParkData.toJson(),
    "taxi_park_uuid": taxiParkUuid,
  };
}

class Group {
  Group({
    this.uuid,
    this.name,
    this.description,
    this.distributionWeight,
    this.servicesUuid,
    this.tag,
    this.defaultTariffUuid,
    this.defaultTariffOfflineUuid,
  });

  final String uuid;
  final String name;
  final String description;
  final int distributionWeight;
  final dynamic servicesUuid;
  final dynamic tag;
  final String defaultTariffUuid;
  final String defaultTariffOfflineUuid;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    uuid: json["uuid"],
    name: json["name"],
    description: json["description"],
    distributionWeight: json["distribution_weight"],
    servicesUuid: json["services_uuid"],
    tag: json["tag"],
    defaultTariffUuid: json["default_tariff_uuid"],
    defaultTariffOfflineUuid: json["default_tariff_offline_uuid"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "description": description,
    "distribution_weight": distributionWeight,
    "services_uuid": servicesUuid,
    "tag": tag,
    "default_tariff_uuid": defaultTariffUuid,
    "default_tariff_offline_uuid": defaultTariffOfflineUuid,
  };
}

class DriverPromotion {
  DriverPromotion({
    this.booster,
    this.rentedAuto,
    this.brandSticker,
  });

  final bool booster;
  final bool rentedAuto;
  final bool brandSticker;

  factory DriverPromotion.fromJson(Map<String, dynamic> json) => DriverPromotion(
    booster: json["booster"],
    rentedAuto: json["rented_auto"],
    brandSticker: json["brand_sticker"],
  );

  Map<String, dynamic> toJson() => {
    "booster": booster,
    "rented_auto": rentedAuto,
    "brand_sticker": brandSticker,
  };
}

class DriverTariff {
  DriverTariff({
    this.uuid,
    this.offline,
    this.driversGroupsUuid,
    this.tariffDefault,
    this.isSecret,
    this.tariffType,
    this.name,
    this.comment,
    this.color,
    this.rejExp,
    this.commExp,
    this.period,
    this.periodPrice,
    this.payedAt,
  });

  final String uuid;
  final bool offline;
  final dynamic driversGroupsUuid;
  final bool tariffDefault;
  final bool isSecret;
  final String tariffType;
  final String name;
  final String comment;
  final String color;
  final String rejExp;
  final String commExp;
  final int period;
  final int periodPrice;
  final int payedAt;

  factory DriverTariff.fromJson(Map<String, dynamic> json) => DriverTariff(
    uuid: json["uuid"],
    offline: json["offline"],
    driversGroupsUuid: json["drivers_groups_uuid"],
    tariffDefault: json["default"],
    isSecret: json["is_secret"],
    tariffType: json["tariff_type"],
    name: json["name"],
    comment: json["comment"],
    color: json["color"],
    rejExp: json["rej_exp"],
    commExp: json["comm_exp"],
    period: json["period"],
    periodPrice: json["period_price"],
    payedAt: json["payed_at"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "offline": offline,
    "drivers_groups_uuid": driversGroupsUuid,
    "default": tariffDefault,
    "is_secret": isSecret,
    "tariff_type": tariffType,
    "name": name,
    "comment": comment,
    "color": color,
    "rej_exp": rejExp,
    "comm_exp": commExp,
    "period": period,
    "period_price": periodPrice,
    "payed_at": payedAt,
  };
}

class TaxiParkData {
  TaxiParkData({
    this.uuid,
    this.name,
    this.comment,
    this.regionUuid,
  });

  final String uuid;
  final String name;
  final String comment;
  final String regionUuid;

  factory TaxiParkData.fromJson(Map<String, dynamic> json) => TaxiParkData(
    uuid: json["uuid"],
    name: json["name"],
    comment: json["comment"],
    regionUuid: json["region_uuid"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "comment": comment,
    "region_uuid": regionUuid,
  };
}

class PaymentMeta {
  PaymentMeta({
    this.isPrepaid,
    this.receiptUrl,
    this.qrCodeUrl,
    this.additionalData,
  });

  final bool isPrepaid;
  final String receiptUrl;
  final String qrCodeUrl;
  final dynamic additionalData;

  factory PaymentMeta.fromJson(Map<String, dynamic> json) => PaymentMeta(
    isPrepaid: json["_is_prepaid"],
    receiptUrl: json["receipt_url"],
    qrCodeUrl: json["qr_code_url"],
    additionalData: json["additional_data"],
  );

  Map<String, dynamic> toJson() => {
    "_is_prepaid": isPrepaid,
    "receipt_url": receiptUrl,
    "qr_code_url": qrCodeUrl,
    "additional_data": additionalData,
  };
}

class PhoneLine {
  PhoneLine({
    this.uuid,
    this.serviceUuid,
    this.name,
    this.comment,
  });

  final String uuid;
  final String serviceUuid;
  final String name;
  final String comment;

  factory PhoneLine.fromJson(Map<String, dynamic> json) => PhoneLine(
    uuid: json["uuid"],
    serviceUuid: json["service_uuid"],
    name: json["name"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "service_uuid": serviceUuid,
    "name": name,
    "comment": comment,
  };
}

class OrderPromotion {
  OrderPromotion({
    this.isVip,
    this.isUnpaid,
  });

  final bool isVip;
  final bool isUnpaid;

  factory OrderPromotion.fromJson(Map<String, dynamic> json) => OrderPromotion(
    isVip: json["is_vip"],
    isUnpaid: json["is_unpaid"],
  );

  Map<String, dynamic> toJson() => {
    "is_vip": isVip,
    "is_unpaid": isUnpaid,
  };
}

class RouteWayData {
  RouteWayData({
    this.routes,
    this.routeFromDriverToClient,
    this.steps,
  });

  final Routes routes;
  final RouteFromDriverToClient routeFromDriverToClient;
  final List<Routes> steps;

  factory RouteWayData.fromJson(Map<String, dynamic> json) => RouteWayData(
    routes: Routes.fromJson(json["routes"]),
    routeFromDriverToClient: RouteFromDriverToClient.fromJson(json["route_from_driver_to_client"]),
    steps: List<Routes>.from(json["steps"].map((x) => Routes.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "routes": routes.toJson(),
    "route_from_driver_to_client": routeFromDriverToClient.toJson(),
    "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
  };
}

class RouteFromDriverToClient {
  RouteFromDriverToClient({
    this.geometry,
    this.type,
    this.properties,
  });

  final RouteFromDriverToClientGeometry geometry;
  final String type;
  final RouteFromDriverToClientProperties properties;

  factory RouteFromDriverToClient.fromJson(Map<String, dynamic> json) => RouteFromDriverToClient(
    geometry: RouteFromDriverToClientGeometry.fromJson(json["geometry"]),
    type: json["type"],
    properties: RouteFromDriverToClientProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "geometry": geometry.toJson(),
    "type": type,
    "properties": properties.toJson(),
  };
}

class RouteFromDriverToClientGeometry {
  RouteFromDriverToClientGeometry({
    this.coordinates,
    this.type,
  });

  final dynamic coordinates;
  final String type;

  factory RouteFromDriverToClientGeometry.fromJson(Map<String, dynamic> json) => RouteFromDriverToClientGeometry(
    coordinates: json["coordinates"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": coordinates,
    "type": type,
  };
}

class RouteFromDriverToClientProperties {
  RouteFromDriverToClientProperties({
    this.duration,
    this.distance,
  });

  final int duration;
  final int distance;

  factory RouteFromDriverToClientProperties.fromJson(Map<String, dynamic> json) => RouteFromDriverToClientProperties(
    duration: json["duration"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "duration": duration,
    "distance": distance,
  };
}

class Routes {
  Routes({
    this.geometry,
    this.type,
    this.properties,
  });

  final RouteToClientGeometry geometry;
  final String type;
  final RouteFromDriverToClientProperties properties;

  factory Routes.fromJson(Map<String, dynamic> json) => Routes(
    geometry: RouteToClientGeometry.fromJson(json["geometry"]),
    type: json["type"],
    properties: RouteFromDriverToClientProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "geometry": geometry.toJson(),
    "type": type,
    "properties": properties.toJson(),
  };
}

class Route {
  Route({
    this.uuid,
    this.pointType,
    this.unrestrictedValue,
    this.value,
    this.country,
    this.region,
    this.regionType,
    this.type,
    this.city,
    this.category,
    this.cityType,
    this.street,
    this.streetType,
    this.streetWithType,
    this.house,
    this.frontDoor,
    this.comment,
    this.outOfTown,
    this.houseType,
    this.accuracyLevel,
    this.radius,
    this.lat,
    this.lon,
  });

  final String uuid;
  final String pointType;
  final String unrestrictedValue;
  final String value;
  final String country;
  final String region;
  final String regionType;
  final String type;
  final String city;
  final String category;
  final String cityType;
  final String street;
  final String streetType;
  final String streetWithType;
  final String house;
  final int frontDoor;
  final String comment;
  final bool outOfTown;
  final String houseType;
  final int accuracyLevel;
  final int radius;
  final double lat;
  final double lon;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    uuid: json["uuid"],
    pointType: json["point_type"],
    unrestrictedValue: json["unrestricted_value"],
    value: json["value"],
    country: json["country"],
    region: json["region"],
    regionType: json["region_type"],
    type: json["type"],
    city: json["city"],
    category: json["category"],
    cityType: json["city_type"],
    street: json["street"],
    streetType: json["street_type"],
    streetWithType: json["street_with_type"],
    house: json["house"],
    frontDoor: json["front_door"],
    comment: json["comment"],
    outOfTown: json["out_of_town"],
    houseType: json["house_type"],
    accuracyLevel: json["accuracy_level"],
    radius: json["radius"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "point_type": pointType,
    "unrestricted_value": unrestrictedValue,
    "value": value,
    "country": country,
    "region": region,
    "region_type": regionType,
    "type": type,
    "city": city,
    "category": category,
    "city_type": cityType,
    "street": street,
    "street_type": streetType,
    "street_with_type": streetWithType,
    "house": house,
    "front_door": frontDoor,
    "comment": comment,
    "out_of_town": outOfTown,
    "house_type": houseType,
    "accuracy_level": accuracyLevel,
    "radius": radius,
    "lat": lat,
    "lon": lon,
  };
}

class Service {
  Service({
    this.uuid,
    this.name,
    this.priceCoefficient,
    this.freight,
    this.productDelivery,
    this.comment,
    this.maxBonusPaymentPercent,
    this.image,
    this.tag,
  });

  final String uuid;
  final String name;
  final int priceCoefficient;
  final bool freight;
  final bool productDelivery;
  final String comment;
  final int maxBonusPaymentPercent;
  final String image;
  final List<String> tag;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    uuid: json["uuid"],
    name: json["name"],
    priceCoefficient: json["price_coefficient"],
    freight: json["freight"],
    productDelivery: json["product_delivery"],
    comment: json["comment"],
    maxBonusPaymentPercent: json["max_bonus_payment_percent"],
    image: json["image"],
    tag: List<String>.from(json["tag"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "price_coefficient": priceCoefficient,
    "freight": freight,
    "product_delivery": productDelivery,
    "comment": comment,
    "max_bonus_payment_percent": maxBonusPaymentPercent,
    "image": image,
    "tag": List<dynamic>.from(tag.map((x) => x)),
  };
}

class OrderTariff {
  OrderTariff({
    this.name,
    this.totalPrice,
    this.fixedPrice,
    this.productsPrice,
    this.guaranteedDriverIncome,
    this.guaranteedDriverIncomeForDelivery,
    this.supplementToGuaranteedIncome,
    this.tariffCalcType,
    this.orderTripTime,
    this.orderCompleateDist,
    this.orderStartTime,
    this.minPaymentWithTime,
    this.currency,
    this.paymentType,
    this.maxBonusPayment,
    this.bonusPayment,
    this.items,
    this.waitingBoarding,
    this.waitingPoint,
    this.timeTaximeter,
    this.waitingPrice,
    this.surge,
    this.precalculated,
  });

  final String name;
  final int totalPrice;
  final int fixedPrice;
  final int productsPrice;
  final int guaranteedDriverIncome;
  final int guaranteedDriverIncomeForDelivery;
  final int supplementToGuaranteedIncome;
  final String tariffCalcType;
  final int orderTripTime;
  final int orderCompleateDist;
  final int orderStartTime;
  final int minPaymentWithTime;
  final String currency;
  final String paymentType;
  final int maxBonusPayment;
  final int bonusPayment;
  final List<Item> items;
  final Map<String, int> waitingBoarding;
  final Map<String, int> waitingPoint;
  final Map<String, int> timeTaximeter;
  final int waitingPrice;
  final dynamic surge;
  final String precalculated;

  factory OrderTariff.fromJson(Map<String, dynamic> json) => OrderTariff(
    name: json["name"],
    totalPrice: json["total_price"],
    fixedPrice: json["fixed_price"],
    productsPrice: json["products_price"],
    guaranteedDriverIncome: json["guaranteed_driver_income"],
    guaranteedDriverIncomeForDelivery: json["guaranteed_driver_income_for_delivery"],
    supplementToGuaranteedIncome: json["supplement_to_guaranteed_income"],
    tariffCalcType: json["tariff_calc_type"],
    orderTripTime: json["order_trip_time"],
    orderCompleateDist: json["order_compleate_dist"],
    orderStartTime: json["order_start_time"],
    minPaymentWithTime: json["min_payment_with_time"],
    currency: json["currency"],
    paymentType: json["payment_type"],
    maxBonusPayment: json["max_bonus_payment"],
    bonusPayment: json["bonus_payment"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    waitingBoarding: Map.from(json["waiting_boarding"]).map((k, v) => MapEntry<String, int>(k, v)),
    waitingPoint: Map.from(json["waiting_point"]).map((k, v) => MapEntry<String, int>(k, v)),
    timeTaximeter: Map.from(json["time_taximeter"]).map((k, v) => MapEntry<String, int>(k, v)),
    waitingPrice: json["waiting_price"],
    surge: json["surge"],
    precalculated: json["precalculated"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "total_price": totalPrice,
    "fixed_price": fixedPrice,
    "products_price": productsPrice,
    "guaranteed_driver_income": guaranteedDriverIncome,
    "guaranteed_driver_income_for_delivery": guaranteedDriverIncomeForDelivery,
    "supplement_to_guaranteed_income": supplementToGuaranteedIncome,
    "tariff_calc_type": tariffCalcType,
    "order_trip_time": orderTripTime,
    "order_compleate_dist": orderCompleateDist,
    "order_start_time": orderStartTime,
    "min_payment_with_time": minPaymentWithTime,
    "currency": currency,
    "payment_type": paymentType,
    "max_bonus_payment": maxBonusPayment,
    "bonus_payment": bonusPayment,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "waiting_boarding": Map.from(waitingBoarding).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "waiting_point": Map.from(waitingPoint).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "time_taximeter": Map.from(timeTaximeter).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "waiting_price": waitingPrice,
    "surge": surge,
    "precalculated": precalculated,
  };
}

class Item {
  Item({
    this.name,
    this.price,
  });

  final String name;
  final int price;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    name: json["name"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
  };
}

class Taximeter {
  Taximeter({
    this.wait,
    this.distance,
    this.time,
  });

  final List<Wait> wait;
  final List<Distance> distance;
  final List<Distance> time;

  factory Taximeter.fromJson(Map<String, dynamic> json) => Taximeter(
    wait: List<Wait>.from(json["wait"].map((x) => Wait.fromJson(x))),
    distance: List<Distance>.from(json["distance"].map((x) => Distance.fromJson(x))),
    time: List<Distance>.from(json["time"].map((x) => Distance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "wait": List<dynamic>.from(wait.map((x) => x.toJson())),
    "distance": List<dynamic>.from(distance.map((x) => x.toJson())),
    "time": List<dynamic>.from(time.map((x) => x.toJson())),
  };
}

class Distance {
  Distance({
    this.section,
    this.interval,
    this.rate,
  });

  final int section;
  final int interval;
  final int rate;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
    section: json["section"],
    interval: json["interval"],
    rate: json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "section": section,
    "interval": interval,
    "rate": rate,
  };
}

class Wait {
  Wait({
    this.freeTime,
    this.interval,
    this.rateTime,
  });

  final int freeTime;
  final int interval;
  final int rateTime;

  factory Wait.fromJson(Map<String, dynamic> json) => Wait(
    freeTime: json["free_time"],
    interval: json["interval"],
    rateTime: json["rate_time"],
  );

  Map<String, dynamic> toJson() => {
    "free_time": freeTime,
    "interval": interval,
    "rate_time": rateTime,
  };
}

class PhotocontrolsDatum {
  PhotocontrolsDatum({
    this.notified,
    this.controlType,
    this.controlTypeTitle,
    this.status,
    this.nextControlTime,
    this.nextControlTimeUnix,
  });

  final bool notified;
  final String controlType;
  final String controlTypeTitle;
  final String status;
  final DateTime nextControlTime;
  final int nextControlTimeUnix;

  factory PhotocontrolsDatum.fromJson(Map<String, dynamic> json) => PhotocontrolsDatum(
    notified: json["notified"],
    controlType: json["control_type"],
    controlTypeTitle: json["control_type_title"],
    status: json["status"],
    nextControlTime: DateTime.parse(json["next_control_time"]),
    nextControlTimeUnix: json["next_control_time_unix"],
  );

  Map<String, dynamic> toJson() => {
    "notified": notified,
    "control_type": controlType,
    "control_type_title": controlTypeTitle,
    "status": status,
    "next_control_time": nextControlTime.toIso8601String(),
    "next_control_time_unix": nextControlTimeUnix,
  };
}
