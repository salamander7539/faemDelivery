// To parse this JSON data, do
//
//     final driverData = driverDataFromJson(jsonString);

import 'dart:convert';

DriverData driverDataFromJson(String str) => DriverData.fromJson(json.decode(str));

String driverDataToJson(DriverData data) => json.encode(data.toJson());

class DriverData {
  DriverData({
    this.id,
    this.deviceId,
    this.ordersQueue,
    this.createdAt,
    this.updatedAt,
    this.registrationAddress,
    this.livingAddress,
    this.paymentType,
    this.getOrderRadius,
    this.photocontrolData,
    this.uuid,
    this.name,
    this.paymentTypes,
    this.phone,
    this.comment,
    this.stateName,
    this.car,
    this.balance,
    this.cardBalance,
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
    this.meta,
    this.taxiParkData,
    this.taxiParkUuid,
  });

  final int id;
  final String deviceId;
  final String ordersQueue;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String registrationAddress;
  final String livingAddress;
  final String paymentType;
  final int getOrderRadius;
  final dynamic photocontrolData;
  final String uuid;
  final String name;
  final List<String> paymentTypes;
  final String phone;
  final String comment;
  final String stateName;
  final String car;
  final double balance;
  final int cardBalance;
  final int karma;
  final String color;
  final Tariff tariff;
  final List<String> tag;
  final List<AvailableService> availableServices;
  final List<AvailableFeature> availableFeatures;
  final int alias;
  final String regNumber;
  final int activity;
  final Promotion promotion;
  final Group group;
  final dynamic blacklist;
  final Meta meta;
  final TaxiParkData taxiParkData;
  final String taxiParkUuid;

  factory DriverData.fromJson(Map<String, dynamic> json) => DriverData(
    id: json["id"],
    deviceId: json["device_id"],
    ordersQueue: json["orders_queue"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    registrationAddress: json["registration_address"],
    livingAddress: json["living_address"],
    paymentType: json["payment_type"],
    getOrderRadius: json["get_order_radius"],
    photocontrolData: json["photocontrol_data"],
    uuid: json["uuid"],
    name: json["name"],
    paymentTypes: List<String>.from(json["payment_types"].map((x) => x)),
    phone: json["phone"],
    comment: json["comment"],
    stateName: json["state_name"],
    car: json["car"],
    balance: json["balance"],
    cardBalance: json["card_balance"],
    karma: json["karma"],
    color: json["color"],
    tariff: Tariff.fromJson(json["tariff"]),
    tag: List<String>.from(json["tag"].map((x) => x)),
    availableServices: List<AvailableService>.from(json["available_services"].map((x) => AvailableService.fromJson(x))),
    availableFeatures: List<AvailableFeature>.from(json["available_features"].map((x) => AvailableFeature.fromJson(x))),
    alias: json["alias"],
    regNumber: json["reg_number"],
    activity: json["activity"],
    promotion: Promotion.fromJson(json["promotion"]),
    group: Group.fromJson(json["group"]),
    blacklist: json["blacklist"],
    meta: Meta.fromJson(json["meta"]),
    taxiParkData: TaxiParkData.fromJson(json["taxi_park_data"]),
    taxiParkUuid: json["taxi_park_uuid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "device_id": deviceId,
    "orders_queue": ordersQueue,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "registration_address": registrationAddress,
    "living_address": livingAddress,
    "payment_type": paymentType,
    "get_order_radius": getOrderRadius,
    "photocontrol_data": photocontrolData,
    "uuid": uuid,
    "name": name,
    "payment_types": List<dynamic>.from(paymentTypes.map((x) => x)),
    "phone": phone,
    "comment": comment,
    "state_name": stateName,
    "car": car,
    "balance": balance,
    "card_balance": cardBalance,
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
    "meta": meta.toJson(),
    "taxi_park_data": taxiParkData.toJson(),
    "taxi_park_uuid": taxiParkUuid,
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
    servicesUuid: List<String>.from(json["services_uuid"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "comment": comment,
    "price": price,
    "tag": List<dynamic>.from(tag.map((x) => x)),
    "services_uuid": List<dynamic>.from(servicesUuid.map((x) => x)),
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
    this.imagesSet,
    this.tag,
  });

  final String uuid;
  final String name;
  var priceCoefficient;
  final bool freight;
  final bool productDelivery;
  final String comment;
  final int maxBonusPaymentPercent;
  final String image;
  final ImagesSet imagesSet;
  final List<String> tag;

  factory AvailableService.fromJson(Map<String, dynamic> json) => AvailableService(
    uuid: json["uuid"],
    name: json["name"],
    priceCoefficient: json["price_coefficient"],
    freight: json["freight"],
    productDelivery: json["product_delivery"],
    comment: json["comment"],
    maxBonusPaymentPercent: json["max_bonus_payment_percent"],
    image: json["image"],
    imagesSet: ImagesSet.fromJson(json["images_set"]),
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
    "images_set": imagesSet.toJson(),
    "tag": List<dynamic>.from(tag.map((x) => x)),
  };
}

class ImagesSet {
  ImagesSet({
    this.fullFormat,
    this.smallFormat,
    this.mediumFormat,
  });

  final String fullFormat;
  final String smallFormat;
  final String mediumFormat;

  factory ImagesSet.fromJson(Map<String, dynamic> json) => ImagesSet(
    fullFormat: json["full_format"] == null ? null : json["full_format"],
    smallFormat: json["small_format"] == null ? null : json["small_format"],
    mediumFormat: json["medium_format"] == null ? null : json["medium_format"],
  );

  Map<String, dynamic> toJson() => {
    "full_format": fullFormat == null ? null : fullFormat,
    "small_format": smallFormat == null ? null : smallFormat,
    "medium_format": mediumFormat == null ? null : mediumFormat,
  };
}

class Group {
  Group({
    this.uuid,
    this.name,
    this.description,
    this.distributionWeight,
    this.servicesUuid,
    this.photocontrolTemplates,
    this.tag,
    this.defaultTariffUuid,
    this.defaultTariffOfflineUuid,
  });

  final String uuid;
  final String name;
  final String description;
  final int distributionWeight;
  final dynamic servicesUuid;
  final dynamic photocontrolTemplates;
  final dynamic tag;
  final String defaultTariffUuid;
  final String defaultTariffOfflineUuid;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    uuid: json["uuid"],
    name: json["name"],
    description: json["description"],
    distributionWeight: json["distribution_weight"],
    servicesUuid: json["services_uuid"],
    photocontrolTemplates: json["photocontrol_templates"],
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
    "photocontrol_templates": photocontrolTemplates,
    "tag": tag,
    "default_tariff_uuid": defaultTariffUuid,
    "default_tariff_offline_uuid": defaultTariffOfflineUuid,
  };
}

class Meta {
  Meta({
    this.blockedAt,
    this.blockedUntil,
    this.unblockedAt,
  });

  final int blockedAt;
  final int blockedUntil;
  final int unblockedAt;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    blockedAt: json["blocked_at"],
    blockedUntil: json["blocked_until"],
    unblockedAt: json["unblocked_at"],
  );

  Map<String, dynamic> toJson() => {
    "blocked_at": blockedAt,
    "blocked_until": blockedUntil,
    "unblocked_at": unblockedAt,
  };
}

class Promotion {
  Promotion({
    this.booster,
    this.rentedAuto,
    this.brandSticker,
  });

  final bool booster;
  final bool rentedAuto;
  final bool brandSticker;

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
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

class Tariff {
  Tariff({
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

  factory Tariff.fromJson(Map<String, dynamic> json) => Tariff(
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

class Markup {
  Markup({
    this.taxiParkUuid,
    this.rejectionExpr,
    this.completeExpr,
    this.forPeriodTariffs,
    this.completeVars,
    this.rejectionVars,
    this.title,
    this.description,
  });

  final String taxiParkUuid;
  final String rejectionExpr;
  final String completeExpr;
  final int forPeriodTariffs;
  final dynamic completeVars;
  final dynamic rejectionVars;
  final String title;
  final String description;

  factory Markup.fromJson(Map<String, dynamic> json) => Markup(
    taxiParkUuid: json["taxi_park_uuid"],
    rejectionExpr: json["rejection_expr"],
    completeExpr: json["complete_expr"],
    forPeriodTariffs: json["for_period_tariffs"],
    completeVars: json["complete_vars"],
    rejectionVars: json["rejection_vars"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "taxi_park_uuid": taxiParkUuid,
    "rejection_expr": rejectionExpr,
    "complete_expr": completeExpr,
    "for_period_tariffs": forPeriodTariffs,
    "complete_vars": completeVars,
    "rejection_vars": rejectionVars,
    "title": title,
    "description": description,
  };
}

class TaxiParkData {
  TaxiParkData({
    this.uuid,
    this.name,
    this.comment,
    this.friendlyUuid,
    this.unwantedUuid,
    this.regionUuid,
    this.representative,
  });

  final String uuid;
  final String name;
  final String comment;
  final List<dynamic> friendlyUuid;
  final List<String> unwantedUuid;
  final String regionUuid;
  final Representative representative;

  factory TaxiParkData.fromJson(Map<String, dynamic> json) => TaxiParkData(
    uuid: json["uuid"],
    name: json["name"],
    comment: json["comment"],
    friendlyUuid: List<dynamic>.from(json["friendly_uuid"].map((x) => x)),
    unwantedUuid: List<String>.from(json["unwanted_uuid"].map((x) => x)),
    regionUuid: json["region_uuid"],
    representative: Representative.fromJson(json["representative"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "comment": comment,
    "friendly_uuid": List<dynamic>.from(friendlyUuid.map((x) => x)),
    "unwanted_uuid": List<dynamic>.from(unwantedUuid.map((x) => x)),
    "region_uuid": regionUuid,
    "representative": representative.toJson(),
  };
}

class Representative {
  Representative({
    this.name,
    this.inn,
  });

  final String name;
  final String inn;

  factory Representative.fromJson(Map<String, dynamic> json) => Representative(
    name: json["name"],
    inn: json["inn"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "inn": inn,
  };
}
