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
  List<SoloGameWord>? words;

  SoloGame({this.id, this.words});

  SoloGame.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['words'] != null) {
      words = <SoloGameWord>[];
      json['words'].forEach((v) {
        words!.add(SoloGameWord.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (words != null) {
      data['words'] = words!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SoloGameWord {
  String? word;
  List<String>? clues;
  String? jokerClue;

  SoloGameWord({this.word, this.clues, this.jokerClue});

  SoloGameWord.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    clues = json['clues'].cast<String>();
    jokerClue = json['jokerClue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
    data['clues'] = clues;
    data['jokerClue'] = jokerClue;
    return data;
  }
}
