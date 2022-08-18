class CategoryModel {
  String? key;
  String? name;

  CategoryModel({this.key, this.name});

  factory CategoryModel.fromJson(Map<dynamic, dynamic> json) {
    return CategoryModel(key: json['key'], name: json['name']);
  }
}
