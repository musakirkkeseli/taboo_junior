class SoloGameModel {
  List<SoloGame>? data;

  SoloGameModel({this.data});

  SoloGameModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SoloGame>[];
      json['data'].forEach((v) {
        data!.add(SoloGame.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SoloGame {
  int? id;
  String? word;
  List<String>? clues;

  SoloGame({this.id, this.word, this.clues});

  SoloGame.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    word = json['word'];
    clues = json['clues'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['word'] = word;
    data['clues'] = clues;
    return data;
  }
}
