import 'package:faem_delivery/tokenData/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

var orderDetail;

Future<Null> getDetailOrdersData(var uuid) async {
  var url = 'https://driver.apis.stage.faem.pro/api/v2/freeorder/$uuid';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $newToken'
  });
  if (response.statusCode == 200) {
    orderDetail = json.decode(response.body);
    print(response.body);
  } else {
    print("Error order with code ${response.statusCode}");
    print(response.body);
  }
}

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.clientUuid,
    this.clientPhone,
    this.ordersData,
  });

  final String clientUuid;
  final String clientPhone;
  final List<OrdersDatum> ordersData;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    clientUuid: json["client_uuid"],
    clientPhone: json["client_phone"],
    ordersData: List<OrdersDatum>.from(json["orders_data"].map((x) => OrdersDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "client_uuid": clientUuid,
    "client_phone": clientPhone,
    "orders_data": List<dynamic>.from(ordersData.map((x) => x.toJson())),
  };
}

class OrdersDatum {
  OrdersDatum({
    this.uuid,
    this.comment,
    this.routes,
    this.routeWayData,
    this.features,
    this.tariff,
    this.fixedPrice,
    this.service,
    this.increasedFare,
    this.driver,
    this.owner,
    this.client,
    this.source,
    this.driverRating,
    this.clientRating,
    this.isOptional,
    this.withoutDelivery,
    this.orderStart,
    this.cancelTime,
    this.promotion,
    this.arrivalTime,
    this.productsData,
    this.paymentType,
    this.paymentMeta,
    this.id,
    this.clientUuid,
    this.serviceUuid,
    this.callbackPhone,
    this.featuresUuids,
    this.createdAt,
    this.createdAtUnix,
    this.updatedAt,
    this.visibility,
    this.state,
    this.stateTitle,
    this.driverLocation,
  });

  final String uuid;
  final String comment;
  final List<Route> routes;
  final RouteWayData routeWayData;
  final dynamic features;
  final OrdersDatumTariff tariff;
  final int fixedPrice;
  final Service service;
  final int increasedFare;
  final Driver driver;
  final Owner owner;
  final Client client;
  final String source;
  final Rating driverRating;
  final Rating clientRating;
  final bool isOptional;
  final bool withoutDelivery;
  final DateTime orderStart;
  final DateTime cancelTime;
  final OrdersDatumPromotion promotion;
  final int arrivalTime;
  final ProductsData productsData;
  final String paymentType;
  final PaymentMeta paymentMeta;
  final int id;
  final String clientUuid;
  final String serviceUuid;
  final String callbackPhone;
  final dynamic featuresUuids;
  final DateTime createdAt;
  final int createdAtUnix;
  final DateTime updatedAt;
  final bool visibility;
  final String state;
  final String stateTitle;
  final DriverLocation driverLocation;

  factory OrdersDatum.fromJson(Map<String, dynamic> json) => OrdersDatum(
    uuid: json["uuid"],
    comment: json["comment"],
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
    routeWayData: RouteWayData.fromJson(json["route_way_data"]),
    features: json["features"],
    tariff: OrdersDatumTariff.fromJson(json["tariff"]),
    fixedPrice: json["fixed_price"],
    service: Service.fromJson(json["service"]),
    increasedFare: json["increased_fare"],
    driver: Driver.fromJson(json["driver"]),
    owner: Owner.fromJson(json["owner"]),
    client: Client.fromJson(json["client"]),
    source: json["source"],
    driverRating: Rating.fromJson(json["driver_rating"]),
    clientRating: Rating.fromJson(json["client_rating"]),
    isOptional: json["is_optional"],
    withoutDelivery: json["without_delivery"],
    orderStart: DateTime.parse(json["order_start"]),
    cancelTime: DateTime.parse(json["cancel_time"]),
    promotion: OrdersDatumPromotion.fromJson(json["promotion"]),
    arrivalTime: json["arrival_time"],
    productsData: ProductsData.fromJson(json["products_data"]),
    paymentType: json["payment_type"],
    paymentMeta: PaymentMeta.fromJson(json["payment_meta"]),
    id: json["id"],
    clientUuid: json["client_uuid"],
    serviceUuid: json["service_uuid"],
    callbackPhone: json["callback_phone"],
    featuresUuids: json["features_uuids"],
    createdAt: DateTime.parse(json["created_at"]),
    createdAtUnix: json["created_at_unix"],
    updatedAt: DateTime.parse(json["updated_at"]),
    visibility: json["visibility"],
    state: json["state"],
    stateTitle: json["state_title"],
    driverLocation: DriverLocation.fromJson(json["driver_location"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "comment": comment,
    "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
    "route_way_data": routeWayData.toJson(),
    "features": features,
    "tariff": tariff.toJson(),
    "fixed_price": fixedPrice,
    "service": service.toJson(),
    "increased_fare": increasedFare,
    "driver": driver.toJson(),
    "owner": owner.toJson(),
    "client": client.toJson(),
    "source": source,
    "driver_rating": driverRating.toJson(),
    "client_rating": clientRating.toJson(),
    "is_optional": isOptional,
    "without_delivery": withoutDelivery,
    "order_start": orderStart.toIso8601String(),
    "cancel_time": cancelTime.toIso8601String(),
    "promotion": promotion.toJson(),
    "arrival_time": arrivalTime,
    "products_data": productsData.toJson(),
    "payment_type": paymentType,
    "payment_meta": paymentMeta.toJson(),
    "id": id,
    "client_uuid": clientUuid,
    "service_uuid": serviceUuid,
    "callback_phone": callbackPhone,
    "features_uuids": featuresUuids,
    "created_at": createdAt.toIso8601String(),
    "created_at_unix": createdAtUnix,
    "updated_at": updatedAt.toIso8601String(),
    "visibility": visibility,
    "state": state,
    "state_title": stateTitle,
    "driver_location": driverLocation.toJson(),
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
    this.maxServiceLevel,
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
  });

  final String uuid;
  final String name;
  final List<String> paymentTypes;
  final String phone;
  final String comment;
  final String stateName;
  final String car;
  final int balance;
  final int maxServiceLevel;
  final double karma;
  final String color;
  final DriverTariff tariff;
  final List<String> tag;
  final List<AvailableService> availableServices;
  final List<AvailableFeature> availableFeatures;
  final int alias;
  final String regNumber;
  final int activity;
  final DriverPromotion promotion;
  final Group group;
  final dynamic blacklist;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    uuid: json["uuid"],
    name: json["name"],
    paymentTypes: List<String>.from(json["payment_types"].map((x) => x)),
    phone: json["phone"],
    comment: json["comment"],
    stateName: json["state_name"],
    car: json["car"],
    balance: json["balance"],
    maxServiceLevel: json["max_service_level"],
    karma: json["karma"].toDouble(),
    color: json["color"],
    tariff: DriverTariff.fromJson(json["tariff"]),
    tag: List<String>.from(json["tag"].map((x) => x)),
    availableServices: List<AvailableService>.from(json["available_services"].map((x) => AvailableService.fromJson(x))),
    availableFeatures: List<AvailableFeature>.from(json["available_features"].map((x) => AvailableFeature.fromJson(x))),
    alias: json["alias"],
    regNumber: json["reg_number"],
    activity: json["activity"],
    promotion: DriverPromotion.fromJson(json["promotion"]),
    group: Group.fromJson(json["group"]),
    blacklist: json["blacklist"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "payment_types": List<dynamic>.from(paymentTypes.map((x) => x)),
    "phone": phone,
    "comment": comment,
    "state_name": stateName,
    "car": car,
    "balance": balance,
    "max_service_level": maxServiceLevel,
    "karma": karma,
    "color": color,
    "tariff": tariff.toJson(),
    "tag": List<dynamic>.from(tag.map((x) => x)),
    "available_services": List<dynamic>.from(availableServices.map((x) => x.toJson())),
    "available_features": List<dynamic>.from(availableFeatures.map((x) => x.toJson())),
    "alias": alias,
    "reg_number": regNumber,
    "activity": activity,
    "promotion": promotion.toJson(),
    "group": group.toJson(),
    "blacklist": blacklist,
  };
}

class AvailableFeature {
  AvailableFeature({
    this.uuid,
    this.name,
    this.comment,
    this.price,
    this.tag,
    this.servicesUuid,
  });

  final String uuid;
  final String name;
  final String comment;
  final int price;
  final List<String> tag;
  final List<String> servicesUuid;

  factory AvailableFeature.fromJson(Map<String, dynamic> json) => AvailableFeature(
    uuid: json["uuid"],
    name: json["name"],
    comment: json["comment"],
    price: json["price"],
    tag: List<String>.from(json["tag"].map((x) => x)),
    servicesUuid: json["services_uuid"] == null ? null : List<String>.from(json["services_uuid"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "comment": comment,
    "price": price,
    "tag": List<dynamic>.from(tag.map((x) => x)),
    "services_uuid": servicesUuid == null ? null : List<dynamic>.from(servicesUuid.map((x) => x)),
  };
}

class AvailableService {
  AvailableService({
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
  final double priceCoefficient;
  final bool freight;
  final bool productDelivery;
  final String comment;
  final int maxBonusPaymentPercent;
  final String image;
  final List<String> tag;

  factory AvailableService.fromJson(Map<String, dynamic> json) => AvailableService(
    uuid: json["uuid"],
    name: json["name"],
    priceCoefficient: json["price_coefficient"].toDouble(),
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
  final List<String> tag;
  final String defaultTariffUuid;
  final String defaultTariffOfflineUuid;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    uuid: json["uuid"],
    name: json["name"],
    description: json["description"],
    distributionWeight: json["distribution_weight"],
    servicesUuid: json["services_uuid"],
    tag: List<String>.from(json["tag"].map((x) => x)),
    defaultTariffUuid: json["default_tariff_uuid"],
    defaultTariffOfflineUuid: json["default_tariff_offline_uuid"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "description": description,
    "distribution_weight": distributionWeight,
    "services_uuid": servicesUuid,
    "tag": List<dynamic>.from(tag.map((x) => x)),
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
  final List<String> driversGroupsUuid;
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
    driversGroupsUuid: List<String>.from(json["drivers_groups_uuid"].map((x) => x)),
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
    "drivers_groups_uuid": List<dynamic>.from(driversGroupsUuid.map((x) => x)),
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

class DriverLocation {
  DriverLocation({
    this.lat,
    this.long,
  });

  final double lat;
  final double long;

  factory DriverLocation.fromJson(Map<String, dynamic> json) => DriverLocation(
    lat: json["lat"].toDouble(),
    long: json["long"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
  };
}

class Owner {
  Owner({
    this.uuid,
    this.serviceUuid,
    this.name,
    this.comment,
  });

  final String uuid;
  final String serviceUuid;
  final String name;
  final String comment;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
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

class ProductsData {
  ProductsData({
    this.store,
    this.preparationTime,
    this.buyout,
    this.orderNumberInStore,
    this.products,
  });

  final Store store;
  final int preparationTime;
  final bool buyout;
  final String orderNumberInStore;
  final List<Product> products;

  factory ProductsData.fromJson(Map<String, dynamic> json) => ProductsData(
    store: Store.fromJson(json["store"]),
    preparationTime: json["preparation_time"],
    buyout: json["buyout"],
    orderNumberInStore: json["order_number_in_store"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "store": store.toJson(),
    "preparation_time": preparationTime,
    "buyout": buyout,
    "order_number_in_store": orderNumberInStore,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  Product({
    this.uuid,
    this.weight,
    this.name,
    this.comment,
    this.available,
    this.price,
    this.image,
    this.storeUuid,
    this.toppings,
    this.number,
    this.selectedVariant,
  });

  final String uuid;
  final int weight;
  final String name;
  final String comment;
  final bool available;
  final int price;
  final String image;
  final String storeUuid;
  final dynamic toppings;
  final int number;
  final SelectedVariant selectedVariant;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    uuid: json["uuid"],
    weight: json["weight"],
    name: json["name"],
    comment: json["comment"],
    available: json["available"],
    price: json["price"],
    image: json["image"],
    storeUuid: json["store_uuid"],
    toppings: json["toppings"],
    number: json["number"],
    selectedVariant: SelectedVariant.fromJson(json["selected_variant"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "weight": weight,
    "name": name,
    "comment": comment,
    "available": available,
    "price": price,
    "image": image,
    "store_uuid": storeUuid,
    "toppings": toppings,
    "number": number,
    "selected_variant": selectedVariant.toJson(),
  };
}

class SelectedVariant {
  SelectedVariant({
    this.uuid,
    this.name,
    this.standard,
    this.price,
    this.comment,
  });

  final String uuid;
  final String name;
  final bool standard;
  final int price;
  final String comment;

  factory SelectedVariant.fromJson(Map<String, dynamic> json) => SelectedVariant(
    uuid: json["uuid"],
    name: json["name"],
    standard: json["standard"],
    price: json["price"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "standard": standard,
    "price": price,
    "comment": comment,
  };
}

class Store {
  Store({
    this.uuid,
    this.name,
    this.phone,
    this.comment,
    this.ownDelivery,
    this.image,
    this.available,
    this.workSchedule,
    this.type,
    this.productCategory,
    this.orderPreparationTimeSecond,
  });

  final String uuid;
  final String name;
  final String phone;
  final String comment;
  final bool ownDelivery;
  final String image;
  final bool available;
  final List<WorkSchedule> workSchedule;
  final String type;
  final List<String> productCategory;
  final int orderPreparationTimeSecond;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    uuid: json["uuid"],
    name: json["name"],
    phone: json["phone"],
    comment: json["comment"],
    ownDelivery: json["own_delivery"],
    image: json["image"],
    available: json["available"],
    workSchedule: List<WorkSchedule>.from(json["work_schedule"].map((x) => WorkSchedule.fromJson(x))),
    type: json["type"],
    productCategory: List<String>.from(json["product_category"].map((x) => x)),
    orderPreparationTimeSecond: json["order_preparation_time_second"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "phone": phone,
    "comment": comment,
    "own_delivery": ownDelivery,
    "image": image,
    "available": available,
    "work_schedule": List<dynamic>.from(workSchedule.map((x) => x.toJson())),
    "type": type,
    "product_category": List<dynamic>.from(productCategory.map((x) => x)),
    "order_preparation_time_second": orderPreparationTimeSecond,
  };
}

class WorkSchedule {
  WorkSchedule({
    this.weekDay,
    this.dayOff,
    this.workBeginning,
    this.workEnding,
  });

  final int weekDay;
  final bool dayOff;
  final int workBeginning;
  final int workEnding;

  factory WorkSchedule.fromJson(Map<String, dynamic> json) => WorkSchedule(
    weekDay: json["week_day"],
    dayOff: json["day_off"],
    workBeginning: json["work_beginning"],
    workEnding: json["work_ending"],
  );

  Map<String, dynamic> toJson() => {
    "week_day": weekDay,
    "day_off": dayOff,
    "work_beginning": workBeginning,
    "work_ending": workEnding,
  };
}

class OrdersDatumPromotion {
  OrdersDatumPromotion({
    this.isVip,
    this.isUnpaid,
  });

  final bool isVip;
  final bool isUnpaid;

  factory OrdersDatumPromotion.fromJson(Map<String, dynamic> json) => OrdersDatumPromotion(
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
  final List<Step> steps;

  factory RouteWayData.fromJson(Map<String, dynamic> json) => RouteWayData(
    routes: Routes.fromJson(json["routes"]),
    routeFromDriverToClient: RouteFromDriverToClient.fromJson(json["route_from_driver_to_client"]),
    steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
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

  final Geometry geometry;
  final String type;
  final RouteFromDriverToClientProperties properties;

  factory RouteFromDriverToClient.fromJson(Map<String, dynamic> json) => RouteFromDriverToClient(
    geometry: Geometry.fromJson(json["geometry"]),
    type: json["type"],
    properties: RouteFromDriverToClientProperties.fromJson(json["properties"]),
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
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
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

  final Geometry geometry;
  final String type;
  final RoutesProperties properties;

  factory Routes.fromJson(Map<String, dynamic> json) => Routes(
    geometry: Geometry.fromJson(json["geometry"]),
    type: json["type"],
    properties: RoutesProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "geometry": geometry.toJson(),
    "type": type,
    "properties": properties.toJson(),
  };
}

class RoutesProperties {
  RoutesProperties({
    this.duration,
    this.distance,
  });

  final int duration;
  final double distance;

  factory RoutesProperties.fromJson(Map<String, dynamic> json) => RoutesProperties(
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
  final RoutesProperties properties;

  factory Step.fromJson(Map<String, dynamic> json) => Step(
    geometry: Geometry.fromJson(json["geometry"]),
    type: json["type"],
    properties: RoutesProperties.fromJson(json["properties"]),
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

class OrdersDatumTariff {
  OrdersDatumTariff({
    this.name,
    this.totalPrice,
    this.productsPrice,
    this.guaranteedDriverIncome,
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
  });

  final String name;
  final int totalPrice;
  final int productsPrice;
  final int guaranteedDriverIncome;
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

  factory OrdersDatumTariff.fromJson(Map<String, dynamic> json) => OrdersDatumTariff(
    name: json["name"],
    totalPrice: json["total_price"],
    productsPrice: json["products_price"],
    guaranteedDriverIncome: json["guaranteed_driver_income"],
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
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "total_price": totalPrice,
    "products_price": productsPrice,
    "guaranteed_driver_income": guaranteedDriverIncome,
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
