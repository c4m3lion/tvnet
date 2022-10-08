import 'dart:convert';

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
