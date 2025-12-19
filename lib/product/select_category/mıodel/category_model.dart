class CategoryModel {
  String? id;
  String? name;
  String? color;
  String? cover;

  CategoryModel({this.id, this.name, this.color, this.cover});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    data['cover'] = cover;
    return data;
  }
}
