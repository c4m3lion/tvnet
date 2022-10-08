class Epg {
  Epg({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.description,
  });

  String id;
  String title;
  int start;
  int end;
  String description;

  factory Epg.fromJson(Map<String, dynamic> json) => Epg(
        id: json["id"],
        title: json["title"],
        start: json["start"],
        end: json["end"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "start": start,
        "end": end,
        "description": description,
      };
}
