import 'package:http/http.dart' as http;
import 'package:where_to_app/models/place.dart';
import 'dart:convert' as convert;

import 'package:where_to_app/models/place_search.dart';


class PlacesService {

  final key = 'AIzaSyAkAHHEdiykJTWJC4c1WSYAFDk0ulNDMkc';

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=establishment&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace (String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<Place>> getPlaces (double lat, double lng, String placeType, String radius) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat%2C$lng&radius=$radius&type=$placeType&key=$key';
    print(url);
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print(json);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }

  Future<List<Place>> getSurprisePlaces (double lat, double lng, String placeType, num distance, num maxPrice) async
  {
    var url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat%2C$lng&radius=$distance&type=$placeType&maxprice=$maxPrice&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();

  }


}