import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

List orders = [];

Future<dynamic> getOrdersData() async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/freeorders?number=30&service=Доставка';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $newToken'
  });
  if (response.statusCode == 200) {
    orders = json.decode(response.body);
    //print("getOrdersData: ${response.body}");
  } else {
    print("Error order with code ${response.statusCode}");
  }
  return orders;
}

// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

List<Orders> ordersFromJson(String str) => List<Orders>.from(json.decode(str).map((x) => Orders.fromJson(x)));

String ordersToJson(List<Orders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Orders {
  Orders({
    this.offer,
    this.order,
    this.taximeter,
  });

  final Offer offer;
  final Order order;
  final Taximeter taximeter;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    offer: Offer.fromJson(json["offer"]),
    order: Order.fromJson(json["order"]),
    taximeter: Taximeter.fromJson(json["taximeter"]),
  );

  Map<String, dynamic> toJson() => {
    "offer": offer.toJson(),
    "order": order.toJson(),
    "taximeter": taximeter.toJson(),
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
  });

  final String uuid;
  final String driverUuid;
  final String orderUuid;
  final String offerType;
  final int responseTime;
  final int driverId;
  final String comment;
  final int tripTime;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    uuid: json["uuid"] as String,
    driverUuid: json["driver_uuid"] as String,
    orderUuid: json["order_uuid"] as String,
    offerType: json["offer_type"] as String,
    responseTime: json["response_time"],
    driverId: json["driver_id"],
    comment: json["comment"] as String,
    tripTime: json["trip_time"],
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
    this.service,
    this.driver,
    this.owner,
    this.client,
    this.orderStart,
    this.cancelTime,
    this.createdAt,
  });

  final String uuid;
  final String comment;
  final List<Route> routes;
  final RouteWayData routeWayData;
  final dynamic features;
  final OrderTariff tariff;
  final Service service;
  final Driver driver;
  final Owner owner;
  final Client client;
  final DateTime orderStart;
  final DateTime cancelTime;
  final DateTime createdAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    uuid: json["uuid"] as String,
    comment: json["comment"] as String,
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
    routeWayData: RouteWayData.fromJson(json["route_way_data"]),
    features: json["features"],
    tariff: OrderTariff.fromJson(json["tariff"]),
    service: Service.fromJson(json["service"]),
    driver: Driver.fromJson(json["driver"]),
    owner: Owner.fromJson(json["owner"]),
    client: Client.fromJson(json["client"]),
    orderStart: DateTime.parse(json["order_start"]),
    cancelTime: DateTime.parse(json["cancel_time"]),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "comment": comment,
    "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
    "route_way_data": routeWayData.toJson(),
    "features": features,
    "tariff": tariff.toJson(),
    "service": service.toJson(),
    "driver": driver.toJson(),
    "owner": owner.toJson(),
    "client": client.toJson(),
    "order_start": orderStart.toIso8601String(),
    "cancel_time": cancelTime.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
  };
}

class Client {
  Client({
    this.uuid,
    this.name,
    this.karma,
    this.mainPhone,
    this.phones,
    this.comment,
  });

  final String uuid;
  final String name;
  final int karma;
  final String mainPhone;
  final dynamic phones;
  final String comment;

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    uuid: json["uuid"] as String,
    name: json["name"] as String,
    karma: json["karma"],
    mainPhone: json["main_phone"] as String,
    phones: json["phones"],
    comment: json["comment"] as String,
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "karma": karma,
    "main_phone": mainPhone,
    "phones": phones,
    "comment": comment,
  };
}

class Driver {
  Driver({
    this.uuid,
    this.name,
    this.phone,
    this.comment,
    this.stateName,
    this.car,
    this.karma,
    this.color,
    this.tariff,
    this.tag,
    this.availableServices,
    this.availableFeatures,
    this.alias,
    this.regNumber,
  });

  final String uuid;
  final String name;
  final String phone;
  final String comment;
  final String stateName;
  final String car;
  final int karma;
  final String color;
  final DriverTariff tariff;
  final dynamic tag;
  final dynamic availableServices;
  final dynamic availableFeatures;
  final String alias;
  final String regNumber;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    uuid: json["uuid"] as String,
    name: json["name"] as String,
    phone: json["phone"] as String,
    comment: json["comment"] as String,
    stateName: json["state_name"] as String,
    car: json["car"] as String,
    karma: json["karma"],
    color: json["color"] as String,
    tariff: DriverTariff.fromJson(json["tariff"]),
    tag: json["tag"],
    availableServices: json["available_services"],
    availableFeatures: json["available_features"],
    alias: json["alias"] as String,
    regNumber: json["reg_number"] as String,
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "phone": phone,
    "comment": comment,
    "state_name": stateName,
    "car": car,
    "karma": karma,
    "color": color,
    "tariff": tariff.toJson(),
    "tag": tag,
    "available_services": availableServices,
    "available_features": availableFeatures,
    "alias": alias,
    "reg_number": regNumber,
  };
}

class DriverTariff {
  DriverTariff({
    this.uuid,
    this.tariffDefault,
    this.name,
    this.rejExp,
    this.commExp,
    this.comment,
  });

  final String uuid;
  final bool tariffDefault;
  final String name;
  final String rejExp;
  final String commExp;
  final String comment;

  factory DriverTariff.fromJson(Map<String, dynamic> json) => DriverTariff(
    uuid: json["uuid"] as String,
    tariffDefault: json["default"],
    name: json["name"] as String,
    rejExp: json["rej_exp"] as String,
    commExp: json["comm_exp"] as String,
    comment: json["comment"] as String,
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "default": tariffDefault,
    "name": name,
    "rej_exp": rejExp,
    "comm_exp": commExp,
    "comment": comment,
  };
}

class Owner {
  Owner({
    this.uuid,
    this.name,
    this.comment,
  });

  final String uuid;
  final String name;
  final String comment;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    uuid: json["uuid"] as String,
    name: json["name"] as String,
    comment: json["comment"] as String,
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "comment": comment,
  };
}

class RouteWayData {
  RouteWayData({
    this.routes,
    this.steps,
    this.stepsString,
  });

  final Routes routes;
  final List<Step> steps;
  final String stepsString;

  factory RouteWayData.fromJson(Map<String, dynamic> json) => RouteWayData(
    routes: Routes.fromJson(json["routes"]),
    steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
    stepsString: json["steps_string"] as String,
  );

  Map<String, dynamic> toJson() => {
    "routes": routes.toJson(),
    "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
    "steps_string": stepsString,
  };
}

class Routes {
  Routes({
    this.geometry,
    this.type,
    this.properties,
  });

  final Geometry geometry;
  final String type;
  final Properties properties;

  factory Routes.fromJson(Map<String, dynamic> json) => Routes(
    geometry: Geometry.fromJson(json["geometry"]),
    type: json["type"] as String,
    properties: Properties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "geometry": geometry.toJson(),
    "type": type,
    "properties": properties.toJson(),
  };
}

class Geometry {
  Geometry({
    this.coordinates,
    this.type,
  });

  final List<List<double>> coordinates;
  final String type;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    coordinates: List<List<double>>.from(json["coordinates"].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
    type: json["type"] as String,
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "type": type,
  };
}

class Properties {
  Properties({
    this.duration,
    this.distance,
  });

  final int duration;
  final double distance;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    duration: json["duration"],
    distance: json["distance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "duration": duration,
    "distance": distance,
  };
}

class Step {
  Step({
    this.geometry,
    this.type,
    this.properties,
  });

  final Geometry geometry;
  final String type;
  final Properties properties;

  factory Step.fromJson(Map<String, dynamic> json) => Step(
    geometry: Geometry.fromJson(json["geometry"]),
    type: json["type"] as String,
    properties: Properties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "geometry": geometry.toJson(),
    "type": type,
    "properties": properties.toJson(),
  };
}

class Route {
  Route({
    this.unrestrictedValue,
    this.value,
    this.country,
    this.region,
    this.regionType,
    this.city,
    this.cityType,
    this.street,
    this.streetType,
    this.streetWithType,
    this.house,
    this.outOfTown,
    this.houseType,
    this.accuracyLevel,
    this.radius,
    this.lat,
    this.lon,
  });

  final String unrestrictedValue;
  final String value;
  final String country;
  final String region;
  final String regionType;
  final String city;
  final String cityType;
  final String street;
  final String streetType;
  final String streetWithType;
  final String house;
  final bool outOfTown;
  final String houseType;
  final int accuracyLevel;
  final int radius;
  final double lat;
  final double lon;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    unrestrictedValue: json["unrestricted_value"] as String,
    value: json["value"] as String,
    country: json["country"] as String,
    region: json["region"] as String,
    regionType: json["region_type"] as String,
    city: json["city"] as String,
    cityType: json["city_type"] as String,
    street: json["street"] as String,
    streetType: json["street_type"] as String,
    streetWithType: json["street_with_type"] as String,
    house: json["house"] as String,
    outOfTown: json["out_of_town"],
    houseType: json["house_type"] as String,
    accuracyLevel: json["accuracy_level"],
    radius: json["radius"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "unrestricted_value": unrestrictedValue,
    "value": value,
    "country": country,
    "region": region,
    "region_type": regionType,
    "city": city,
    "city_type": cityType,
    "street": street,
    "street_type": streetType,
    "street_with_type": streetWithType,
    "house": house,
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
    this.comment,
    this.tag,
  });

  final String uuid;
  final String name;
  final double priceCoefficient;
  final bool freight;
  final String comment;
  final List<String> tag;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    uuid: json["uuid"] as String,
    name: json["name"] as String,
    priceCoefficient: json["price_coefficient"].toDouble(),
    freight: json["freight"],
    comment: json["comment"] as String,
    tag: List<String>.from(json["tag"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "price_coefficient": priceCoefficient,
    "freight": freight,
    "comment": comment,
    "tag": List<dynamic>.from(tag.map((x) => x)),
  };
}

class OrderTariff {
  OrderTariff({
    this.name,
    this.totalPrice,
    this.currency,
    this.paymentType,
    this.items,
    this.waitingBoarding,
    this.waitingPoint,
  });

  final String name;
  final int totalPrice;
  final String currency;
  final String paymentType;
  final List<Item> items;
  final Map<String, int> waitingBoarding;
  final Map<String, int> waitingPoint;

  factory OrderTariff.fromJson(Map<String, dynamic> json) => OrderTariff(
    name: json["name"] as String,
    totalPrice: json["total_price"],
    currency: json["currency"] as String,
    paymentType: json["payment_type"] as String,
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    waitingBoarding: Map.from(json["waiting_boarding"]).map((k, v) => MapEntry<String, int>(k, v)),
    waitingPoint: Map.from(json["waiting_point"]).map((k, v) => MapEntry<String, int>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "total_price": totalPrice,
    "currency": currency,
    "payment_type": paymentType,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "waiting_boarding": Map.from(waitingBoarding).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "waiting_point": Map.from(waitingPoint).map((k, v) => MapEntry<String, dynamic>(k, v)),
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
    name: json["name"] as String,
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
