class TabuModel {
  String? word;
  List? taboo;

  TabuModel({this.word, this.taboo});

  TabuModel.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    taboo = json['taboo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
    data['taboo'] = taboo;
    return data;
  }
}
