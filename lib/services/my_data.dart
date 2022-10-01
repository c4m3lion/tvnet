import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyData {
  static String currentChannelId = "";
  static String currentCategoryId = "";

  static List<Channel> channels = List.empty(growable: true);
  static List<Category> categories = List.empty(growable: true);

  static Map<String, dynamic> playBackUrlMap = {};

  static String name = "";
  static String token = "";
  static String macAdress = "";

  static late SharedPreferences localStorage;

  void setCurrentChannelId(String id) {
    MyData.currentChannelId = id;
    localStorage.setString("currentChannelId", id);
  }

  Channel findChannelById(String id) {
    return MyData.channels.firstWhere((element) => element.id == id,
        orElse: () => Channel.empty());
  }

  Channel? getCurrentChannel() {
    return MyData.channels
        .firstWhere((element) => element.id == MyData.currentChannelId);
  }
}

// objects
class Category {
  Category({
    required this.id,
    required this.name,
    required this.position,
  });

  Category.empty({
    this.id = "",
    this.name = "",
    this.position = 0,
  });

  String id;
  String name;
  int position;

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        position: json["position"],
      );
}

class Channel {
  Channel({
    required this.id,
    required this.lcn,
    required this.position,
    required this.name,
    required this.category,
    required this.archive,
    required this.isProtected,
    required this.icon,
  });

  Channel.empty({
    this.id = "",
    this.lcn = 0,
    this.position = 0,
    this.name = "",
    this.archive = false,
    this.isProtected = false,
    this.icon = "",
  });

  String id;
  int lcn;
  int position;
  String name;
  Category? category;
  bool archive;
  bool isProtected;
  String icon;
  String? url;

  factory Channel.fromRawJson(String str) => Channel.fromJson(json.decode(str));

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        lcn: json["lcn"],
        position: json["position"],
        name: json["name"],
        category: MyData.categories
            .firstWhere((element) => element.id == json["category"]),
        archive: json["archive"],
        isProtected: json["isProtected"],
        icon: json["icon"],
      );
}
