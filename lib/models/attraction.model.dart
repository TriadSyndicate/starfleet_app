class AttractionModel {
  String? id;
  String? geoID;
  Map? attractionData;

  AttractionModel({this.id, this.geoID, this.attractionData});

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
        id: json['_id'], geoID: json['name'], attractionData: json['data']);
  }
}
