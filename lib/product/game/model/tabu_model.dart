class TabuModel {
  String? word;
  List<String>? forbidden;
  String? difficulty;
  String? id;

  TabuModel({this.word, this.forbidden, this.difficulty, this.id});

  TabuModel.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    forbidden = json['forbidden'].cast<String>();
    difficulty = json['difficulty'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
    data['forbidden'] = forbidden;
    data['difficulty'] = difficulty;
    data['id'] = id;
    return data;
  }
}
