class LocationModel {
  String? id;
  String? name;
  String? geoID;
  List? attractions;

  LocationModel({this.id, this.name, this.geoID, this.attractions});

  factory LocationModel.fromJson(Map<dynamic, dynamic> json) {
    return LocationModel(
        id: json['_id'],
        name: json['name'],
        geoID: json['geoID'],
        attractions: json['attractions']);
  }
}
