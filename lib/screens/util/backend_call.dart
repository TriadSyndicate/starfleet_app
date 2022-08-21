import 'dart:convert';
import 'package:http/http.dart';
import 'package:starfleet_app/models/attraction.model.dart';
import 'package:starfleet_app/models/category.model.dart';
import 'package:starfleet_app/models/location.model.dart';

class APIServices {
  String endpoint = 'https://recommender-backend-5.herokuapp.com/api/v1';

  Future<Map> getLocationId(name) async {
    var str = name.split(",");
    print(str);
    Response response = await post(Uri.parse('$endpoint' '/location'),
        body: {"locationName": '${str[0]}'});
    if (response.statusCode == 200) {
      final Map result = jsonDecode(response.body)['response'];
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<LocationModel> getLocationDetail(Map locationId) async {
    Response response = await post(Uri.parse('$endpoint' '/location/details'),
        body: locationId);
    if (response.statusCode == 200) {
      final Map result = jsonDecode(response.body);
      if (result['exists'] == null) {
        Response responsex = await post(
            Uri.parse('$endpoint' '/location/details'),
            body: locationId);
        final Map resultx = jsonDecode(responsex.body)['exists'];
        return LocationModel.fromJson(resultx);
      } else {
        return LocationModel.fromJson(result['exists']);
      }
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<CategoryModel>> getCategoryList(LocationModel loc) async {
    List<String> lst = loc.attractions!.map((e) => e.toString()).toList();
    var pp = {"attractions": lst};
    Response response = await post(
        Uri.parse('$endpoint' '/location/categories'),
        body: json.encode(pp),
        headers: {'Content-type': 'application/json'});
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['response'];
      return result.map(((e) => CategoryModel.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<AttractionModel>> getAttractionList(LocationModel loc) async {
    List<String> lst = loc.attractions!.map((e) => e.toString()).toList();
    var pp = {"attractions": lst};
    Response response = await post(
        Uri.parse('$endpoint' '/location/attractions'),
        body: json.encode(pp),
        headers: {'Content-type': 'application/json'});
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['response'];
      return result.map(((e) => AttractionModel.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
