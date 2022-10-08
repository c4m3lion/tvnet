import 'dart:convert';

import 'package:tvnet/services/my_network.dart';

import '../services/my_globals.dart' as globals;
import 'Category.dart';

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

  String id;
  int lcn;
  int position;
  String name;
  Category? category;
  bool archive;
  bool isProtected;
  String icon;
  String? _url;
  bool favorite = false;

  Future<String> getUrl() async {
    _url ??= await getPlayBack(channelId: id, token: globals.token);
    return _url!;
  }

  factory Channel.fromRawJson(String str) => Channel.fromJson(json.decode(str));

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        lcn: json["lcn"],
        position: json["position"],
        name: json["name"],
        category: globals.categories
            .firstWhere((element) => element.id == json["category"]),
        archive: json["archive"],
        isProtected: json["isProtected"],
        icon: json["icon"],
      );
}
