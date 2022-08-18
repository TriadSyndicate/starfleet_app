class AttractionModel {
  String? id;
  String? geoID;
  Object? attractionData;

  AttractionModel({this.id, this.geoID, this.attractionData});

  factory AttractionModel.fromJson(Map<dynamic, dynamic> json) {
    return AttractionModel(
        id: json['_id'], geoID: json['name'], attractionData: json['data']);
  }
}
