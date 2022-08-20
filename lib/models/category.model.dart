class CategoryModel {
  String? key;
  String? name;

  int? count;

  CategoryModel({this.key, this.name, this.count});

  factory CategoryModel.fromJson(Map<dynamic, dynamic> json) {
    return CategoryModel(key: json['key'], name: json['name']);
  }
}
