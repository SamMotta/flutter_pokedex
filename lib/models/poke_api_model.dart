class PokeAPIModel {
  int? count;
  String? next;
  String? previous;
  List<PokeInfo>? infoResults;

  PokeAPIModel({this.count, this.next, this.previous, this.infoResults});

  PokeAPIModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      infoResults = <PokeInfo>[];
      json['results'].forEach((v) {
        infoResults!.add(PokeInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (infoResults != null) {
      data['results'] = infoResults!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PokeInfo {
  String? name;
  String? url;

  PokeInfo({this.name, this.url});

  PokeInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
