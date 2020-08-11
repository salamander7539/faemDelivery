import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// To parse this JSON data, do
//
//     final deliverInitData = deliverInitDataFromJson(jsonString);

Future<void> getOrdersData() async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/freeorders?number=30&sorttype=activity&service=Стандарт';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $newToken'
  });
  if (response.statusCode == 200) {
    print(response.body);
    var jsonResponse = json.decode(response.body);
    var price = new DeliverInitData.fromJson(jsonResponse);
  } else {
    print("Error order with code ${response.statusCode}");
    print("${response.body}");
  }
}

List<DeliverInitData> deliverInitDataFromJson(String str) => List<DeliverInitData>.from(json.decode(str).map((x) => DeliverInitData.fromJson(x)));

class DeliverInitData {
  DeliverInitData({
    this.offer,
    this.order,
    this.taximeter,
  });

  final Offer offer;
  final Order order;
  final Taximeter taximeter;

  factory DeliverInitData.fromJson(Map<String, dynamic> json) => DeliverInitData(
    offer: Offer.fromJson(json["offer"]),
    order: Order.fromJson(json["order"]),
    taximeter: Taximeter.fromJson(json["taximeter"]),
  );

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
    uuid: json["uuid"],
    driverUuid: json["driver_uuid"],
    orderUuid: json["order_uuid"],
    offerType: json["offer_type"],
    responseTime: json["response_time"],
    driverId: json["driver_id"],
    comment: json["comment"],
    tripTime: json["trip_time"],
  );
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
    uuid: json["uuid"],
    comment: json["comment"],
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
    uuid: json["uuid"],
    name: json["name"],
    karma: json["karma"],
    mainPhone: json["main_phone"],
    phones: json["phones"],
    comment: json["comment"],
  );

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
    uuid: json["uuid"],
    name: json["name"],
    phone: json["phone"],
    comment: json["comment"],
    stateName: json["state_name"],
    car: json["car"],
    karma: json["karma"],
    color: json["color"],
    tariff: DriverTariff.fromJson(json["tariff"]),
    tag: json["tag"],
    availableServices: json["available_services"],
    availableFeatures: json["available_features"],
    alias: json["alias"],
    regNumber: json["reg_number"],
  );
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
    uuid: json["uuid"],
    tariffDefault: json["default"],
    name: json["name"],
    rejExp: json["rej_exp"],
    commExp: json["comm_exp"],
    comment: json["comment"],
  );
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
    uuid: json["uuid"],
    name: json["name"],
    comment: json["comment"],
  );
}

class RouteWayData {
  RouteWayData({
    this.routes,
    this.steps,
    this.stepsString,
  });

  final Routes routes;
  final List<Routes> steps;
  final String stepsString;

  factory RouteWayData.fromJson(Map<String, dynamic> json) => RouteWayData(
    routes: Routes.fromJson(json["routes"]),
    steps: List<Routes>.from(json["steps"].map((x) => Routes.fromJson(x))),
    stepsString: json["steps_string"],
  );
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
    type: json["type"],
    properties: Properties.fromJson(json["properties"]),
  );
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
    type: json["type"],
  );
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
    unrestrictedValue: json["unrestricted_value"],
    value: json["value"],
    country: json["country"],
    region: json["region"],
    regionType: json["region_type"],
    city: json["city"],
    cityType: json["city_type"],
    street: json["street"],
    streetType: json["street_type"],
    streetWithType: json["street_with_type"],
    house: json["house"],
    outOfTown: json["out_of_town"],
    houseType: json["house_type"],
    accuracyLevel: json["accuracy_level"],
    radius: json["radius"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
  );
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
    uuid: json["uuid"],
    name: json["name"],
    priceCoefficient: json["price_coefficient"].toDouble(),
    freight: json["freight"],
    comment: json["comment"],
    tag: List<String>.from(json["tag"].map((x) => x)),
  );

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
    name: json["name"],
    totalPrice: json["total_price"],
    currency: json["currency"],
    paymentType: json["payment_type"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    waitingBoarding: Map.from(json["waiting_boarding"]).map((k, v) => MapEntry<String, int>(k, v)),
    waitingPoint: Map.from(json["waiting_point"]).map((k, v) => MapEntry<String, int>(k, v)),
  );

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
}
